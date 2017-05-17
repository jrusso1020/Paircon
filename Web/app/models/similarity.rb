# == Schema Information
#
# Table name: similarities
#
#  similarity_id       :string(30)       not null, primary key
#  user_paper_id       :string(30)
#  conference_paper_id :string(30)
#  similarity_score    :decimal(, )
#  md5hash             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_similarities_on_similarity_id                          (similarity_id) UNIQUE
#  index_similarities_on_user_paper_id_and_conference_paper_id  (user_paper_id,conference_paper_id) UNIQUE
#

# Model responsible for Similarity objects
class Similarity < ApplicationRecord
  has_one :paper_user, class_name: 'Paper', foreign_key: :paper_id, primary_key: :user_paper_id
  has_one :paper_conference, class_name: 'Paper', foreign_key: :paper_id, primary_key: :conference_paper_id

  before_create :init_id

  self.primary_key = :similarity_id

  private

  # Create Similarity id
  def init_id
    self.id = CodeGenerator.code(Similarity.new, Similarity.primary_key.to_s, 30)
  end
end
