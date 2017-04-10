class NotificationsController < ApplicationController
  before_action :authenticate_user!

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

  def read_notification
    current_user.last_notifications_read = Time.now
    current_user.save!(:validate => false)
  end

end