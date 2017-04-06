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
  belongs_to :creator, :class_name => 'User' , :foreign_key => 'owner_id'

  scope :of_user, lambda { |user_id| where(recipient_id: user_id) }
  scope :from_user, lambda { |user_id| where(owner_id: user_id) }
  scope :recent, lambda { |from_time| where("#{table_name}.created_at >= ?", from_time) }  
  scope :of_filter_type, lambda { |filter_type| where(trackable_type: FILTER_TYPES[filter_type]) }
  scope :filter_only, -> { where("#{table_name}.key IN (?)",
                                 ['user.create', 'conference.create', 'conference.archive', 'conference.publish', 'post.create']) }
  FILTER_TYPES = {
    1 => Conference.to_s
  }

  NOTIFICATION_PAGE_LIMIT = 49
  NOTIFICATION_LIST_LIMIT = 14
  MAX_DAYS = 7
  
  def self.find_all_notifications(user, limit = nil, filter_type = nil)
    from_time = Time.now.utc.to_date - 1.week

    notifications = Notification.where(recipient_id: user.id).filter_only.recent(from_time).order("#{Notification.table_name}.created_at DESC").limit(limit)
    notifications = notifications.of_filter_type(filter_type.to_i) if filter_type.to_i != 0

    notifications
  end
end
 
