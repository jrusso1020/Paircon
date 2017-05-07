# == Schema Information
#
# Table name: papers
#
# *id*::         <tt>string(30), not null, primary key</tt>
# *title*::      <tt>string</tt>
# *pdf_link*::   <tt>text</tt>
# *md5hash*::    <tt>string</tt>
# *path*::       <tt>text</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

require 'digest/md5'

class Paper < ApplicationRecord
  has_many :conference_papers, dependent: :destroy
  has_many :user_papers, dependent: :destroy

  PAPER_MIME_TYPES = ['application/pdf']

  has_attached_file :pdf
  validates_attachment :pdf, content_type: { content_type: PAPER_MIME_TYPES }
  before_create :init_id

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

  def get_author_information
    dict = []
    self.author.each_with_index do |item, index|
      dict.push({author: self.author[index], affiliation: self.affiliation[index], email: self.email[index]})
    end

    dict.to_json
  end

  def save_pdf_path(filepath)
    self.pdf = File.open(filepath, 'r')
    self.md5hash = Digest::MD5.hexdigest(File.read(filepath))
    self.save!()
  end

  private

  def init_id
    self.id = CodeGenerator.code(Paper.new, 'id', 30)
  end

end
