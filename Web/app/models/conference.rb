# == Schema Information
#
# Table name: conferences
#
# *id*::                 <tt>string(30), not null, primary key</tt>
# *name*::               <tt>string</tt>
# *start_date*::         <tt>datetime</tt>
# *end_date*::           <tt>datetime</tt>
# *url*::                <tt>text</tt>
# *location*::           <tt>string</tt>
# *created_at*::         <tt>datetime, not null</tt>
# *updated_at*::         <tt>datetime, not null</tt>
# *logo_file_name*::     <tt>string</tt>
# *logo_content_type*::  <tt>string</tt>
# *logo_file_size*::     <tt>integer</tt>
# *logo_updated_at*::    <tt>datetime</tt>
# *cover_file_name*::    <tt>string</tt>
# *cover_content_type*:: <tt>string</tt>
# *cover_file_size*::    <tt>integer</tt>
# *cover_updated_at*::   <tt>datetime</tt>
# *description*::        <tt>string(255), default("")</tt>
# *domain*::             <tt>string(255), default("")</tt>
# *publish*::            <tt>boolean, default(FALSE)</tt>
# *archive*::            <tt>boolean, default(FALSE)</tt>
# *phone*::              <tt>string(255), default("")</tt>
# *email*::              <tt>string(255), default("")</tt>
#--
# == Schema Information End
#++

require 'fileutils'
require 'conferences/conference_utils'

class Conference < ApplicationRecord
  include PublicActivity::Common

  has_many :notification, foreign_key: 'trackable_id', class_name: 'Notification', dependent: :destroy

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

  BULK_SPREADSHEET_MIME_TYPE = ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
  BULK_ARCHIVE_MIME_TYPE = ['application/zip']

  def logo_picture
    if !self.logo_file_name.blank?
      return self.logo.try(:url)
    else
      return 'Paircon_logo.png'
    end
  end

  def logo_path
    if !self.logo.path.blank?
      return self.logo.path
    else
      return Rails.root.join('app/assets/images/Paircon_logo.png')
    end
  end

  def cover_photo
    if !self.cover_file_name.blank?
      return self.cover.try(:url)
    end
  end


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

  def activity key, current_user
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: current_user, recipient: current_user, params: {:conference => self.to_json})
  end

  def get_name id=nil
    self.name.blank? ? "Conference #{id}".strip : self.name.strip
  end

  def end_date_str
    self.end_date.strftime(DATEFORMAT)
  end

  def start_date_str
    self.start_date.strftime(DATEFORMAT)
  end

  def get_conference_pdf_path
    return "#{Rails.root}/public/conference/#{self.id}/pdf"
  end

  def get_conference_txt_path
    return "#{Rails.root}/public/conference/#{self.id}/txt"
  end

  def get_conference_path
    return "#{Rails.root}/public/conference/#{self.id}"
  end

  def bulk_upload spreadsheet, zip
    FileUtils.rm_f get_conference_path
    FileUtils.mkdir_p get_conference_path
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

  def get_counts(post = true, interested = true, resources = true, events = true)
    result = []
    result = result + [self.posts.count] if post
    result = result + [self.users.count] if interested
    result = result + [self.conference_resources.length] if resources
    result = result + [self.conference_events.length] if events

    result
  end

  def is_organizer user
    self.conference_organizers.exists?(user_id: user.id) and !user.attendee?
  end

  def self.my_organizing_conferences user
    Conference.includes(:conference_organizers).where(conference_organizers: {user_id: user.id}).order(:name)
  end

  def self.my_attending_conferences user
    Conference.includes(:conference_attendees).where(conference_attendees: {user_id: user.id}).order(:name)
  end

  def get_pdf_text_path
    return "#{Rails.root}/public/conferences/#{self.id}/txt"
  end
        
  def get_pdf_folder_path
    return "#{Rails.root}/public/conferences/#{self.id}/pdf"
  end

  private

  def init_conference_id
    self.id = CodeGenerator.code(Conference.new, 'id', 30)
  end

  def set_default_time
    self.start_date = Time.now
    self.end_date = Time.now + 1.days
  end

end
