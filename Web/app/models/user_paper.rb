# == Schema Information
#
# Table name: user_papers
#
#  user_paper_id :string(30)       not null, primary key
#  user_id       :string
#  paper_id      :string
#
# Indexes
#
#  index_user_papers_on_paper_id_and_user_id  (paper_id,user_id) UNIQUE
#  index_user_papers_on_user_paper_id         (user_paper_id) UNIQUE
#
class UserPaper < ApplicationRecord
  belongs_to :user
  belongs_to :paper, dependent: :destroy

  has_many :similarities, class_name: 'Similarity', foreign_key: :user_paper_id, primary_key: :user_id, dependent: :destroy

  before_create :init_id

  self.primary_key = :user_paper_id

  private

  # Create User Paper id
  def init_id
    self.id = CodeGenerator.code(UserPaper.new, UserPaper.primary_key.to_s, 30)
  end

end
