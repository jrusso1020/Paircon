# == Schema Information
#
# Table name: conference_attendees
#
# *id*::            <tt>integer, not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *user_id*::       <tt>string(30)</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class ConferenceAttendee < ApplicationRecord
  belongs_to :conference
  belongs_to :user
end
