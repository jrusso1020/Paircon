# == Schema Information
#
# Table name: posts
#
#  id            :string(30)       not null, primary key
#  conference_id :string(30)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_posts_on_conference_id  (conference_id)
#

class Post < ApplicationRecord
  include PublicActivity::Common

  before_create :init_post_id
  belongs_to :conference

  scope :post_subscribers, lambda { |conference_ids| where(conference_id: conference_ids) }

  self.per_page = 5

  # Save teh activity of a post
  def activity key, user
    self.save!(validate: false) unless self.persisted?
    self.create_activity(key, owner: user, params: {:post => self.to_json})
  end

  private

  # Create Post id
  def init_post_id
    self.id = CodeGenerator.code(Post.new, 'id', 30)
  end

end
