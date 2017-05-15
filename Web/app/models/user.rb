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
#  is_scraped              :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

# Model responsible for User objects
class User < ApplicationRecord
  require 'users/user_utils'

  include PublicActivity::Common

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

  # Check if full name is equivalent to passed fullname
  def full_name=(full_name)
    full_name_tokens = full_name.split(/\s+/)

    self.first_name = full_name_tokens[0]
    self.last_name = full_name_tokens[1..-1].join(' ') if (full_name_tokens.size > 0)
  end

  # Get the string version of full name of a user
  def full_name
    "#{self.first_name} #{self.last_name}".strip()
  end

  # Get the profile picture of a user
  def profile_photo
    if !self.logo_file_name.blank?
      return self.logo.try(:url)
    elsif self.gender == 0
      return 'Female.jpg'
    else
      return 'Male.jpg'
    end
  end

  # Get the link to a profile picture
  def profile_photo_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.profile_photo)}"
  end

  # Get the txt folder of a user's papers
  def get_pdf_text_path
    return "#{Rails.root}/public/users/#{self.id}/txt"
  end

  # Get the pdf folder of a user's papers
  def get_pdf_folder_path
    return "#{Rails.root}/public/users/#{self.id}/pdfs"
  end

  # Check if a user is a pending organizer
  def pending_organizer
    Organizer.exists?(user_id: self.id)
  end

  # Get all activity for a user
  def activity key
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: self, recipient: self, params: {:user => self.to_json})
  end

  # Scrape a user's profile
  def scrape_profile
    self.is_scraped = false
    self.save
    # delete earlier profile
    UserUtils.new(self).cleanUserProfile()
    begin
      UserProfileScrapperJob.perform_later(self)
    rescue => e
      Rails.logger.error(e.inspect)
      UserUtils.new(self).scrapeUserProfile()
    end
  end

  # Check if a user is attending a conference already
  def is_attending(conference_id)
    !ConferenceAttendee.find_by(user_id: self.id, conference_id: conference_id).blank?
  end

  # Check to see if all recommendation similarities have been computed for a user and conference
  def all_similarities_generated(conference_id)
    user = self
    conference = Conference.find_by(id: conference_id)
    result = Similarity.where(user_paper_id: user.user_papers.pluck(:paper_id), conference_paper_id: conference.conference_papers.pluck(:paper_id))
    result.size == (user.user_papers.size * conference.conference_papers.size)
  end

  private

  # Create User id
  def init_user_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end

end
