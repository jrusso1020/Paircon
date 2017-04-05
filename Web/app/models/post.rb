class Post < ApplicationRecord
  belongs_to :conference

  before_create :init_post_id

  self.per_page = 5

  private

  def init_post_id
    self.id = CodeGenerator.code(Post.new, 'id', 30)
  end

end
