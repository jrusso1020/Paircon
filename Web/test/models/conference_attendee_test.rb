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

require 'test_helper'

class ConferenceAttendeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
