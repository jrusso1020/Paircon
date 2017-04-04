class Post < ApplicationRecord
  belongs_to :conference

  before_create :init_post_id

  private

  def init_post_id
    self.id = CodeGenerator.code(Post.new, 'id', 30)
  end

end
