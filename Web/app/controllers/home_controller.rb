class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    # notification section
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT)
      @total_notifications = Notification.find_new_notifications(@notifications, current_user)
      # render :partial => 'notifications/notifications_listing'
  end

  def privacy_policy
    render layout: 'home/privacy_policy'
  end

  def terms
    render layout: 'home/terms'
  end

end
