# == Schema Information
#
# Table name: paper_authors
#
# *id*::         <tt>integer, not null, primary key</tt>
# *paper_id*::   <tt>string(30)</tt>
# *user_id*::    <tt>string(30)</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#
# Indexes
#
#  index_paper_authors_on_paper_id_and_user_id  (paper_id,user_id) UNIQUE
#--
# == Schema Information End
#++

require 'test_helper'

class PaperAuthorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
