class HomeController < ApplicationController


  def index
    # notification section
      authenticate_user!
      @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT)
      @total_notifications = Notification.find_new_notifications(@notifications, current_user)
      @conferences_attendee_list = Conference.my_attending_conferences_active(current_user)
      @conferences_organizer_list = Conference.my_organizing_conferences_active(current_user)
     @user_id = current_user.id

  end

  def privacy_policy
    render layout: false
  end

  def terms
    render layout: false
  end



end
