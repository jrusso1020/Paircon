# == Schema Information
#
# Table name: papers
#
#  paper_id         :string(30)       not null, primary key
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
# Indexes
#
#  index_papers_on_paper_id  (paper_id) UNIQUE
#

# Model responsible for Paper objects
class Paper < ApplicationRecord
  require 'digest/md5'
  has_one :conference_paper, dependent: :destroy
  has_one :user_paper, dependent: :destroy

  PAPER_MIME_TYPES = ['application/pdf']

  has_attached_file :pdf
  validates_attachment :pdf, content_type: { content_type: PAPER_MIME_TYPES }
  before_create :init_id

  self.primary_key = :paper_id

  # Saves the uploaded conference paper pdf to the conference pdf folder
  # @param conference_id [String] id of the conference the paper is related to
  # @param filename [String] name of the pdf file
  # @param request_body [HttpRequest Body] http request body which contains the actual pdf content
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

  # Gets the author information of the paper as a dictionary
  # @return [Json] return the json object for the dictionary created
  def get_author_information(is_organizer)
    dict = []
    self.author.each_with_index do |item, index|
      dict.push({author: self.author[index], affiliation: self.affiliation[index], email: is_organizer ? self.email[index] : ''})
    end

    dict.to_json
  end

  # Saves the pdf file as a paperclip attachement to the paper object.
  # Also generates the MD5 hash for the pdf and stores in db
  # @param filepath [String] path to the pdf
  def save_pdf_path(filepath)
    self.pdf = File.open(filepath, 'r')
    self.md5hash = Digest::MD5.hexdigest(File.read(filepath))
    self.save!()
  end

  private

  # Initializes the user id, by assigning a unique 30 character id
  def init_id
    self.id = CodeGenerator.code(Paper.new, Paper.primary_key.to_s, 30)
  end

end
