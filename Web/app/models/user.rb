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
# *sign_in_count*::           <tt>integer, default("0"), not null</tt>
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
# *is_deleted*::              <tt>boolean, default("false")</tt>
# *is_active*::               <tt>boolean, default("false")</tt>
# *is_app_init*::             <tt>boolean, default("false")</tt>
# *time_zone_name*::          <tt>string</tt>
# *last_messages_read*::      <tt>datetime</tt>
# *last_notifications_read*:: <tt>datetime</tt>
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#--
# == Schema Information End
#++

class User < ApplicationRecord

  devise :database_authenticatable, :async, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :omniauthable,
         omniauth_providers: [:google_oauth2, :facebook]

  validates :email, presence: true
  validates :password, confirmation: true

  has_many :identities, dependent: :destroy
  belongs_to :conference_attendee
  belongs_to :paper_author

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}, default_url: 'Male.jpg'
  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  before_create :init_user_id

  enum type: [ :attendee, :organizer, :admin ]

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
    return "#{Rails.root}/public/docs/txt/#{self.id}"
  end

  def get_pdf_folder_path
    return "#{Rails.root}/public/docs/pdfs/#{self.id}"
  end

  private

  def init_user_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end

end
