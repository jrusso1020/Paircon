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

class Similarity < ApplicationRecord
  belongs_to :user_paper, :class_name => "Paper"
  belongs_to :conference_paper, :class_name => "Paper"

  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(Similarity.new, 'id', 30)
  end
end
