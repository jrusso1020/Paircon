# == Schema Information
#
# Table name: activities
#
# *id*::             <tt>integer, not null, primary key</tt>
# *trackable_type*:: <tt>string</tt>
# *trackable_id*::   <tt>string(30)</tt>
# *owner_type*::     <tt>string</tt>
# *owner_id*::       <tt>string(30)</tt>
# *key*::            <tt>string</tt>
# *parameters*::     <tt>text</tt>
# *recipient_type*:: <tt>string</tt>
# *recipient_id*::   <tt>string(30)</tt>
# *created_at*::     <tt>datetime</tt>
# *updated_at*::     <tt>datetime</tt>
#
# Indexes
#
#  index_activities_on_owner_id_and_owner_type          (owner_id,owner_type)
#  index_activities_on_recipient_id_and_recipient_type  (recipient_id,recipient_type)
#  index_activities_on_trackable_id_and_trackable_type  (trackable_id,trackable_type)
#--
# == Schema Information End
#++

class Notification < PublicActivity::Activity
  belongs_to :creator, :class_name => 'User', :foreign_key => 'owner_id'

  scope :of_user, lambda { |user_id| where(recipient_id: user_id) }
  scope :filter_only, -> { where(key: ['user.create', 'conference.create', 'conference.archive', 'conference.publish', 'conference.invite', 'user.publication_update_begin', 'user.publication_update_complete']) }
  scope :from_user, lambda { |user_id| where(owner_id: user_id) }
  scope :post_subscribers, lambda { |post_ids| where(key: ['post.create']).where(trackable_id: post_ids) }
  scope :recent, lambda { |from_time| where("created_at >= ?", from_time) }

  before_create :init_id

  NOTIFICATION_PAGE_LIMIT = 49
  NOTIFICATION_LIST_LIMIT = 14
  MAX_DAYS = 7

  def self.find_all_notifications(user, limit = nil)
    from_time = Time.now.utc.to_date - 1.week
    attending_conferences_id = Conference.active.includes(:conference_attendees).where(conference_attendees: {user_id: user.id}).collect(&:id)
    post_ids = Post.post_subscribers(attending_conferences_id).collect(&:id)

    post_notifications = Notification.post_subscribers(post_ids).recent(from_time).order(created_at: :desc).limit(limit)
    notifications_local = Notification.where(recipient_id: user.id).filter_only.recent(from_time).order(created_at: :desc).limit(limit)
    (post_notifications.or(notifications_local)).order(created_at: :desc).limit(limit)
  end

  def self.find_new_notifications notifications, user
    notifications.where('created_at > ? AND created_at > ?', user.last_notifications_read, Date.today - Notification::MAX_DAYS).limit(Notification::NOTIFICATION_LIST_LIMIT).select('id').size
  end

  private

  def init_id
    self.id = CodeGenerator.code(Notification.new, 'id', 30)
  end
end
 
