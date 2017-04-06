# == Schema Information
#
# Table name: posts
#
# *id*::            <tt>string(30), not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *description*::   <tt>text</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
