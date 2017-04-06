# == Schema Information
#
# Table name: posts
#
# *id*::            <tt>string(30), not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *description*::   <tt>text</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class Post < ApplicationRecord
  belongs_to :conference

  before_create :init_post_id

  self.per_page = 5

  private

  def init_post_id
    self.id = CodeGenerator.code(Post.new, 'id', 30)
  end

end
