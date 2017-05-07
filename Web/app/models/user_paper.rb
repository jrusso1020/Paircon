class UserPaper < ApplicationRecord
  belongs_to :user
  belongs_to :paper, dependent: :destroy

  has_many :similarities, class_name: 'Similarity', foreign_key: :user_paper_id, primary_key: :user_id

  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(UserPaper.new, 'id', 30)
  end

end
