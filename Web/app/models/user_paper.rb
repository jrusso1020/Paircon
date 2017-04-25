class UserPaper < ApplicationRecord
  belongs_to :user
  belongs_to :paper, dependent: :destroy
  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(UserPaper.new, 'id', 30)
  end

end
