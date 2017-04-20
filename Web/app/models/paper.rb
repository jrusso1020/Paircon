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

class Paper < ApplicationRecord
  has_many :conference_papers, dependent: :destroy
  has_many :user_papers, dependent: :destroy
  has_many :similiarities
  has_many :conferences, through: :conference_papers
  has_many :users, through: :user_papers
  has_many :paper_authors, dependent: :destroy
  has_attached_file :pdf
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }
  before_create :init_id
  attr_accessor :affiliation
  attr_accessor :affiliation
  attr_accessor :author

  def save_pdf(conference_id, filename, request_body)
    pdf_folder = Rails.root.join('public', 'conference', conference_id, 'pdf')
    FileUtils.mkdir_p pdf_folder
    new_file = Rails.root.join('public', 'conference', conference_id, 'pdf/' + filename)

    File.open(new_file, 'wb') do |file|
      file.binmode
      file.puts(request_body.read)
    end

    self.pdf = File.open(new_file, 'r')
    self.save!(validate: false)

    File.delete(new_file)
  end

  private

  def init_id
    self.id = CodeGenerator.code(Paper.new, 'id', 30)
  end

end
