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
  has_many :similiarities
  has_many :conferences, through: :conference_papers
  has_attached_file :pdf
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }
  before_create :init_id

  def save_pdf_path(filepath)
    self.pdf = File.open(filepath, "r")
    self.pdf_link = ""
    self.save!()
    File.delete(filepath)
  end

  private

  def init_id
    self.id = CodeGenerator.code(Paper.new, 'id', 30)
  end

end
