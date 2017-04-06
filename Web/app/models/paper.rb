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
  has_many :conference_papers
  has_many :similiarities
  has_many :conferences, through: :conference_papers
end
