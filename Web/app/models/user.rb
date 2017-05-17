# == Schema Information
#
# Table name: users
#
#  user_id                 :string(30)       not null, primary key
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
#  index_users_on_user_id               (user_id) UNIQUE
#

# Model responsible for User objects
class User < ApplicationRecord
  require 'users/user_utils'

  include PublicActivity::Common

  devise :database_authenticatable, :async, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :omniauthable,
         omniauth_providers: [:google_oauth2, :facebook]

  validates_presence_of :email
  validates_confirmation_of :password

  has_many :conference_attendees, dependent: :destroy
  has_many :conference_organizers, dependent: :destroy
  has_many :user_papers, dependent: :destroy

  has_one :organizer, dependent: :destroy
  has_many :identities, dependent: :destroy

  has_many :papers, through: :user_papers

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}, default_url: 'Male.jpg'
  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  before_create :init_user_id

  enum user_type: [:attendee, :organizer, :admin]

  self.primary_key = :user_id

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

  # gets the full link to the profile picture
  # @return [String] link to the profile picture
  def profile_photo_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.profile_photo)}"
  end

  # Gets the path of folder where the text files extracted from pdfs(scrapped from user profile) are stored
  # @return [String] path of the folder
  def get_pdf_text_path
    return "#{Rails.root}/public/users/#{self.id}/txt"
  end

  # Gets the path of folder where the pdf scrapped from user profile are stored
  # @return [String] path of the folder
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

  # Scrape the profile of the user.
  # Sets is_scraped attribute in user database object to false and cleans the earlier profile.
  # creates a background job for profile scrapping.
  # if a job can not be created, scrapes the profile on the spot.
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

  # Checks whether the user is attending a conference
  # @param conference_id [String] conference id for which we need to verify
  # @return [Boolean] status of whether the user is attending the conference
  def is_attending(conference_id)
    !ConferenceAttendee.find_by(user_id: self.id, conference_id: conference_id).blank?
  end

  # Check to see if all recommendation similarities have been computed for a user and conference
  def all_similarities_generated(conference_id)
    user = self
    conference = Conference.find_by(conference_id: conference_id)
    result = Similarity.where(user_paper_id: user.user_papers.pluck(:paper_id), conference_paper_id: conference.conference_papers.pluck(:paper_id))
    result.size == (user.user_papers.size * conference.conference_papers.size)
  end

  private

  # Initializes the user id, by assigning a unique 30 character id
  def init_user_id
    self.id = CodeGenerator.code(User.new, User.primary_key.to_s, 30)
  end

end
