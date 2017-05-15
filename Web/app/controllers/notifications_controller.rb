# Controller primarily responsible for handling Notifications
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # Method used for displaying complete and partial notifications
  # @return [HTML] Renders Index View
  def index
    if params[:referer] == REFERERS[:mini_activity_listing]
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT)
      @total_notifications = Notification.find_new_notifications(@notifications, current_user)
      render :partial => 'notifications_listing'
    else
      read_notification
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_PAGE_LIMIT)
      @total_notifications = Notification.find_new_notifications(@notifications, current_user)
    end
  end

  # Method used for marking notifications as read
  # @return [HTML] Renders Read Notification View
  def read_notification
    current_user.last_notifications_read = Time.now
    current_user.save!(:validate => false)
  end
end