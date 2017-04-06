class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user.last_notifications_read = Time.now
    current_user.save!(:validate => false)
    
    filter_type = params[:filter_type].to_i
    if params[:referer] == REFERERS[:mini_activity_listing]
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT, filter_type)
      render :partial => 'notifications_listing'
    else
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_PAGE_LIMIT, filter_type)
    end
  end

end