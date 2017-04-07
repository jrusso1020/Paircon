# == Schema Information
#
# Table name: posts
#
# *id*::            <tt>string(30), not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *description*::   <tt>text</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#
# Indexes
#
#  index_posts_on_conference_id  (conference_id)
#--
# == Schema Information End
#++

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
