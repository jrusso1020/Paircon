# == Schema Information
#
# Table name: organizers
#
# *id*::         <tt>string(30), not null, primary key</tt>
# *user_id*::    <tt>string</tt>
# *approved*::   <tt>boolean, default(FALSE)</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
