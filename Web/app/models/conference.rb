# == Schema Information
#
# Table name: conferences
#
#  conference_id      :string(30)       not null, primary key
#  name               :string
#  start_date         :datetime
#  end_date           :datetime
#  url                :text
#  location           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  logo_file_name     :string
#  logo_content_type  :string
#  logo_file_size     :integer
#  logo_updated_at    :datetime
#  cover_file_name    :string
#  cover_content_type :string
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  description        :text             default("")
#  domain             :string(255)      default("")
#  publish            :boolean          default(FALSE)
#  archive            :boolean          default(FALSE)
#  phone              :string(255)      default("")
#  email              :string(255)      default("")
#  lat                :decimal(, )
#  long               :decimal(, )
#
# Indexes
#
#  index_conferences_on_conference_id  (conference_id) UNIQUE
#
class Conference < ApplicationRecord
  require 'fileutils'
  require 'conferences/conference_utils'

  include PublicActivity::Common

  has_many :notification, foreign_key: :trackable_id, class_name: 'Notification', dependent: :destroy

  has_many :conference_attendees, dependent: :destroy
  has_many :conference_resources, dependent: :destroy
  has_many :conference_events, dependent: :destroy
  has_many :conference_papers, dependent: :destroy
  has_many :conference_organizers, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :organizers, through: :conference_organizers, source: :user
  has_many :papers, through: :conference_papers
  has_many :users, through: :conference_attendees

  before_create :init_conference_id
  before_create :set_default_time

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}
  has_attached_file :cover, styles: {medium: '1750x250>', thumb: '100x100>'}, default_url: 'Male.jpg'

  scope :not_archived, lambda { where(archive: false) }
  scope :published, lambda { where(publish: true) }

  scope :active, lambda { not_archived.or(published) }

  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}
  validates_attachment :cover, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  # Allowed Types For Spread Sheets in Bulk Upload
  BULK_SPREADSHEET_MIME_TYPE = ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']

  # Allowed Types For Zip Files in Bulk Upload
  BULK_ARCHIVE_MIME_TYPE = ['application/zip']

  self.primary_key = :conference_id

  # Get the conference's logo
  # @return [String] the filename of the logo picture
  def logo_picture
    if !self.logo_file_name.blank?
      self.logo.try(:url)
    else
      'Paircon_logo.png'
    end
  end

  # Get the path to the conference's logo
  # @return [String] the file path of the logo image
  def logo_path
    if !self.logo.path.blank?
      self.logo.path
    else
      Rails.root.join('app/assets/images/Paircon_logo.png')
    end
  end

  # Get the conference's cover photo
  # @return [String] the file path of the cover photo
  def cover_photo
    if !self.cover_file_name.blank?
      self.cover.try(:url)
    end
  end

  # Save the logo or cover photo of a conference
  # @param params [Hash] the parameters hash with name and data to save
  # @param is_logo [Boolean] optional parameter to tell if it is a logo or cover photo
  # @return None
  def save_image(params, is_logo=true)
    FileUtils.mkdir_p "#{Rails.root}/tmp/logo"
    FileUtils.mkdir_p "#{Rails.root}/tmp/cover"
    if (is_logo)
      new_file = "#{Rails.root}/tmp/logo/#{self.id.to_s + '_' + params[:name]}"
    else
      new_file = "#{Rails.root}/tmp/cover/#{self.id.to_s + '_' + params[:name]}"
    end

    File.open(new_file, 'wb') do |file|
      file.write(Base64.decode64 params[:data].split(",")[1])
    end

    if (is_logo)
      self.logo = File.open(new_file, 'r')
    else
      self.cover = File.open(new_file, 'r')
    end

    self.save!(validate: false)

    File.delete(new_file)
  end

  # Save an activity to this conference
  # @param key [String] the key of the activity
  # @param current_user [User] the current user object
  # @return None
  def activity key, current_user
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: current_user, recipient: current_user, params: {:conference => self.to_json})
  end

  # Get the name of this conference
  # @param id [String] the identifier of the conference
  # @return [String] the name of the conference
  def get_name id=nil
    self.name.blank? ? "Conference #{id}".strip : self.name.strip
  end

  # Get string of the end date of this conference
  # @return [String] the end date of the conference
  def end_date_str
    self.end_date.strftime(DATETIMEFORMAT)
  end

  # Get string of the start date of this conference
  # @return [String] the start date of the conference
  def start_date_str
    self.start_date.strftime(DATETIMEFORMAT)
  end

  # Handle the bulk upload of schedule and papers of a conference
  # @param spreadsheet [File] a spreadsheet file to parse
  # @param zip [File] a zip file to unzip
  # @return [Boolean] whether or not the transaction was successful
  # @return [String] the error or success message of the transaction
  def bulk_upload spreadsheet, zip
    FileUtils.rm_f get_pdf_folder_path
    FileUtils.mkdir_p get_pdf_folder_path
    zip_path = get_conference_path + '/' + zip.original_filename
    File.open(zip_path, 'w+') do |f|
      f.binmode
      f.puts(zip.read)
    end
    spreadsheet_path = get_conference_path + '/' + spreadsheet.original_filename
    File.open(spreadsheet_path, 'w+') do |f|
      f.binmode
      f.puts(spreadsheet.read)
    end
    zip.close
    spreadsheet.close
    tran_success, message = ConferenceUtils.parse_spreadsheet(spreadsheet_path, zip_path, self.id)
    return tran_success, message
  end

  # Get the number of posts, attendees, resources, and events for a conference
  # @param post [Boolean] boolean saying whether or not to return the post count
  # @param interested [Boolean] boolean saying whether or not to return the attendee count
  # @param resources [Boolean] boolean saying whether or not to return the resources count
  # @param events [Boolean] boolean saying whether or not to return the events count
  # @return [Array] the counts for the past parameters
  def get_counts(post = true, interested = true, resources = true, events = true)
    result = []
    result = result + [self.posts.count] if post
    result = result + [self.users.count] if interested
    result = result + [self.conference_resources.length] if resources
    result = result + [self.conference_events.length] if events

    result
  end

  # Tell if a given user is an organizer of this conference
  # @param user [User] user object
  # @return [Boolean] whether or not a user is an organizer for this conference
  def is_organizer user
    self.conference_organizers.exists?(user_id: user.id) and !user.attendee?
  end

  # Get all conferences a user organizes
  # @param user [User] user object
  # @return [Array] all the conferences the given user organizes
  def self.my_organizing_conferences user
    Conference.joins(:conference_organizers).where(conference_organizers: {user_id: user.id}).order(:name)
  end

  # Get all conferences a user attends
  # @param user [User] user object
  # @return [Array] all the conferences the given user attends
  def self.my_attending_conferences user
    Conference.joins(:conference_attendees).where(conference_attendees: {user_id: user.id}).order(:name)
  end

  # Get the path to a conference's folder
  # @return [String] the path to the this conference's folder
  def get_conference_path
    "#{Rails.root}/public/conferences/#{self.id}"
  end

  # Get the path to a conference's folder containing txt versions of papers
  # @return [String] the path to this conference's txt document folder
  def get_pdf_text_path
    "#{get_conference_path}/txt"
  end
  
  # Get the path to a conference's folder containing pdf versions of papers
  # @return [String] the path to this conference's pdf document folder
  def get_pdf_folder_path
    "#{get_conference_path}/pdf"
  end

  # Get the paths to a conference's text versions of it's files
  # @return Array[String] an array of paths to files
  def get_text_paths
    self.papers.pluck(:path)
  end

  private

  # Create conference id
  def init_conference_id
    self.id = CodeGenerator.code(Conference.new, Conference.primary_key.to_s, 30)
  end

  # Set the default start and end time of conference
  def set_default_time
    self.start_date = Time.now
    self.end_date = Time.now + 1.days
  end

end
