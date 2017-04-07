# == Schema Information
#
# Table name: conference_attendees
#
# *id*::            <tt>integer, not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *user_id*::       <tt>string(30)</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#
# Indexes
#
#  index_conference_attendees_on_user_id_and_conference_id  (user_id,conference_id) UNIQUE
#--
# == Schema Information End
#++

require 'test_helper'

class ConferenceAttendeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
