# == Schema Information
#
# Table name: papers
#
# *id*::         <tt>integer, not null, primary key</tt>
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
  belongs_to :paper_author
  belongs_to :conference_paper
  belongs_to :similiarity
end
