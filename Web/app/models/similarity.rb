# == Schema Information
#
# Table name: similarities
#
#  id                  :string(30)       not null, primary key
#  user_paper_id       :string(30)
#  conference_paper_id :string(30)
#  similarity_score    :decimal(, )
#  md5hash             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_similarities_on_user_paper_id_and_conference_paper_id  (user_paper_id,conference_paper_id) UNIQUE
#

class Similarity < ApplicationRecord
  belongs_to :user_paper, foreign_key: :user_paper_id, primary_key: :paper_id
  belongs_to :conference_paper, foreign_key: :conference_paper_id, primary_key: :paper_id

  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(Similarity.new, 'id', 30)
  end
end
