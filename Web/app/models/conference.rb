# == Schema Information
#
# Table name: conferences
#
# *id*::         <tt>integer, not null, primary key</tt>
# *name*::       <tt>string</tt>
# *start_date*:: <tt>datetime</tt>
# *end_date*::   <tt>datetime</tt>
# *url*::        <tt>text</tt>
# *location*::   <tt>string</tt>
# *pending*::    <tt>boolean</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

require 'fileutils'

class Conference < ApplicationRecord
  has_many :conference_attendees
  has_many :conference_papers
  has_many :conference_organizers
  has_many :users, through: :conference_attendees
  has_many :users, through: :conference_organizers
  has_many :papers, through: :conference_papers

  before_create :init_conference_id

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}
  has_attached_file :cover, styles: {medium: '1750x250>', thumb: '100x100>'}, default_url: 'Male.jpg'

  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}
  validates_attachment :cover, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  def logo_picture
    if !self.logo_file_name.blank?
      return self.logo.try(:url)
    end
  end

  def logo_picture_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.logo_picture)}"
  end

  def cover_photo
    if !self.cover_file_name.blank?
      return self.cover.try(:url)
    end
  end

  def cover_photo_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.cover_photo)}"
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

  private

  def init_conference_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end
end
