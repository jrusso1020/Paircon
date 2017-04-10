# == Schema Information
#
# Table name: posts
#
# *id*::            <tt>string(30), not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *description*::   <tt>text</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#
# Indexes
#
#  index_posts_on_conference_id  (conference_id)
#--
# == Schema Information End
#++

class Post < ApplicationRecord
  include PublicActivity::Common

  before_create :init_post_id
  belongs_to :conference

  scope :post_subscribers, lambda { |conference_ids| where(conference_id: conference_ids) }

  self.per_page = 5

  def activity key, user
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: user, params: {:post => self.to_json})
  end

  private

  def init_post_id
    self.id = CodeGenerator.code(Post.new, 'id', 30)
  end

end
