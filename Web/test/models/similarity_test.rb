# == Schema Information
#
# Table name: similarities
#
# *id*::               <tt>integer, not null, primary key</tt>
# *paper_id1*::        <tt>string(30)</tt>
# *paper_id2*::        <tt>string(30)</tt>
# *similarity_score*:: <tt>decimal(, )</tt>
# *hash*::             <tt>string</tt>
# *created_at*::       <tt>datetime, not null</tt>
# *updated_at*::       <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

require 'test_helper'

class SimilarityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
