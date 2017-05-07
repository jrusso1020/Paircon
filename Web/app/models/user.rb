# == Schema Information
#
# Table name: users
#
#  id                      :string(30)       not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string
#  last_sign_in_ip         :string
#  confirmation_token      :string
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  first_name              :string(20)
#  last_name               :string(20)
#  default_lang            :string           default("en")
#  is_deleted              :boolean          default(FALSE)
#  is_active               :boolean          default(FALSE)
#  is_app_init             :boolean          default(FALSE)
#  time_zone_name          :string
#  last_messages_read      :datetime
#  last_notifications_read :datetime
#  logo_file_name          :string
#  logo_content_type       :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  phone_number            :string(30)
#  gender                  :integer          default(1)
#  url                     :text
#  user_type               :integer          default("attendee")
#  industry                :string           default("N/A")
#  grad_year               :integer
#  organization            :string           default("N/A")
#  invitation_token        :string
#  invitation_created_at   :datetime
#  invitation_sent_at      :datetime
#  invitation_accepted_at  :datetime
#  invitation_limit        :integer
#  invited_by_type         :string
#  invited_by_id           :integer
#  invitations_count       :integer          default(0)
#  is_scraped              :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include PublicActivity::Common
  include UserHelper

  devise :database_authenticatable, :async, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :omniauthable,
         omniauth_providers: [:google_oauth2, :facebook]

  validates :email, presence: true
  validates :password, confirmation: true

  has_many :conference_attendees, dependent: :destroy
  has_many :conference_organizers, dependent: :destroy
  has_many :user_papers, dependent: :destroy

  has_one :organizer, dependent: :destroy
  has_many :identities, dependent: :destroy

  has_many :conferences, through: :conference_attendees
  has_many :conferences, through: :conference_organizers
  has_many :papers, through: :user_papers

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}, default_url: 'Male.jpg'
  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  before_create :init_user_id

  enum user_type: [:attendee, :organizer, :admin]

  def full_name=(full_name)
    full_name_tokens = full_name.split(/\s+/)

    self.first_name = full_name_tokens[0]
    self.last_name = full_name_tokens[1..-1].join(' ') if (full_name_tokens.size > 0)
  end

  def full_name
    "#{self.first_name} #{self.last_name}".strip()
  end

  def profile_photo
    if !self.logo_file_name.blank?
      return self.logo.try(:url)
    elsif self.gender == 0
      return 'Female.jpg'
    else
      return 'Male.jpg'
    end
  end

  def profile_photo_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.profile_photo)}"
  end

  def get_pdf_text_path
    return "#{Rails.root}/public/users/#{self.id}/txt"
  end

  def get_pdf_folder_path
    return "#{Rails.root}/public/users/#{self.id}/pdfs"
  end

  def pending_organizer
    Organizer.exists?(user_id: self.id)
  end

  def activity key
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: self, recipient: self, params: {:user => self.to_json})
  end

  def scrape_profile
    self.is_scraped = false
    self.save
    # delete earlier profile
    cleanUserProfile(self)
    begin
      UserProfileScrapperJob.perform_later(self)
    rescue => e
      scrapeUserProfile(self)
    end
  end

  def is_attending(conference_id)
    !ConferenceAttendee.find_by(user_id: self.id, conference_id: conference_id).blank?
  end

  def all_similarities_generated(conference_id)
    user = self
    conference = Conference.find_by(id: conference_id)
    result = Similarity.where(user_paper_id: user.user_papers.pluck(:paper_id), conference_paper_id: conference.conference_papers.pluck(:paper_id))
    result.size == (user.user_papers.size * conference.conference_papers.size)
  end

  private

  def init_user_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end

end
