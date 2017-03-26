# == Schema Information
#
# Table name: conference_attendees
#
# *id*::            <tt>integer, not null, primary key</tt>
# *conference_id*:: <tt>integer</tt>
# *user_id*::       <tt>integer</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class ConferenceAttendee < ApplicationRecord
  alias_attribute :attendees, :users
  belongs_to :conference
  belongs_to :user
end
