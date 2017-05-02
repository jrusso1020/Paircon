# == Schema Information
#
# Table name: users
#
# *id*::                      <tt>string(30), not null, primary key</tt>
# *email*::                   <tt>string, default(""), not null</tt>
# *encrypted_password*::      <tt>string, default(""), not null</tt>
# *reset_password_token*::    <tt>string</tt>
# *reset_password_sent_at*::  <tt>datetime</tt>
# *remember_created_at*::     <tt>datetime</tt>
# *sign_in_count*::           <tt>integer, default(0), not null</tt>
# *current_sign_in_at*::      <tt>datetime</tt>
# *last_sign_in_at*::         <tt>datetime</tt>
# *current_sign_in_ip*::      <tt>string</tt>
# *last_sign_in_ip*::         <tt>string</tt>
# *confirmation_token*::      <tt>string</tt>
# *confirmed_at*::            <tt>datetime</tt>
# *confirmation_sent_at*::    <tt>datetime</tt>
# *unconfirmed_email*::       <tt>string</tt>
# *created_at*::              <tt>datetime, not null</tt>
# *updated_at*::              <tt>datetime, not null</tt>
# *first_name*::              <tt>string(20)</tt>
# *last_name*::               <tt>string(20)</tt>
# *default_lang*::            <tt>string, default("en")</tt>
# *is_deleted*::              <tt>boolean, default(FALSE)</tt>
# *is_active*::               <tt>boolean, default(FALSE)</tt>
# *is_app_init*::             <tt>boolean, default(FALSE)</tt>
# *time_zone_name*::          <tt>string</tt>
# *last_messages_read*::      <tt>datetime</tt>
# *last_notifications_read*:: <tt>datetime</tt>
# *logo_file_name*::          <tt>string</tt>
# *logo_content_type*::       <tt>string</tt>
# *logo_file_size*::          <tt>integer</tt>
# *logo_updated_at*::         <tt>datetime</tt>
# *phone_number*::            <tt>string(30)</tt>
# *gender*::                  <tt>integer, default(1)</tt>
# *url*::                     <tt>text</tt>
# *user_type*::               <tt>integer, default("attendee")</tt>
# *user_industry*::           <tt>string, default("")</tt>
# *user_grad_year*::          <tt>integer</tt>
# *user_organization*::       <tt>string, default("")</tt>
# *invitation_token*::        <tt>string</tt>
# *invitation_created_at*::   <tt>datetime</tt>
# *invitation_sent_at*::      <tt>datetime</tt>
# *invitation_accepted_at*::  <tt>datetime</tt>
# *invitation_limit*::        <tt>integer</tt>
# *invited_by_type*::         <tt>string</tt>
# *invited_by_id*::           <tt>integer</tt>
# *invitations_count*::       <tt>integer, default(0)</tt>
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#--
# == Schema Information End
#++

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

  private

  def init_user_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end

end
