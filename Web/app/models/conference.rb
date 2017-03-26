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

class Conference < ApplicationRecord
  has_many :conference_attendees
  has_many :conference_papers
  has_many :conference_organizers
  has_many :users, through: :conference_attendees
  has_many :users, through: :conference_organizers
  has_many :papers, through: :conference_papers
end
