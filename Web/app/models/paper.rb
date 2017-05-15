# == Schema Information
#
# Table name: papers
#
#  id               :string(30)       not null, primary key
#  title            :string
#  md5hash          :string
#  path             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pdf_file_name    :string
#  pdf_content_type :string
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  year             :date
#  abstract         :text
#  author           :text             default([]), is an Array
#  affiliation      :text             default([]), is an Array
#  email            :text             default([]), is an Array
#

require 'digest/md5'

class Paper < ApplicationRecord
  has_one :conference_paper, dependent: :destroy
  has_one :user_paper, dependent: :destroy

  PAPER_MIME_TYPES = ['application/pdf']

  has_attached_file :pdf
  validates_attachment :pdf, content_type: { content_type: PAPER_MIME_TYPES }
  before_create :init_id

  # Save a pdf version of a paper for a given conference
  def save_pdf(conference_id, filename, request_body)
    pdf_folder = Rails.root.join('public', 'conference', conference_id, 'pdf')
    FileUtils.mkdir_p pdf_folder
    new_file = Rails.root.join('public', 'conference', conference_id, 'pdf/' + filename)

    File.open(new_file, 'wb') do |file|
      file.binmode
      file.puts(request_body.read)
    end

    self.pdf = File.open(new_file, 'r')
    self.md5hash = Digest::MD5.hexdigest(File.read(new_file))
    self.save!(validate: false)

    File.delete(new_file)
  end

  # Get the author information for a this paper
  def get_author_information(is_organizer)
    dict = []
    self.author.each_with_index do |item, index|
      dict.push({author: self.author[index], affiliation: self.affiliation[index], email: is_organizer ? self.email[index] : ''})
    end

    dict.to_json
  end

  # Save the path of a pdf
  def save_pdf_path(filepath)
    self.pdf = File.open(filepath, 'r')
    self.md5hash = Digest::MD5.hexdigest(File.read(filepath))
    self.save!()
  end

  private

  # Create Paper id
  def init_id
    self.id = CodeGenerator.code(Paper.new, 'id', 30)
  end

end
