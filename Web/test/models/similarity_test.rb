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
#
# Indexes
#
#  index_similarities_on_paper_id1_and_paper_id2  (paper_id1,paper_id2) UNIQUE
#--
# == Schema Information End
#++

require 'test_helper'

class SimilarityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
