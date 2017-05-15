# Helper used to handle Notifications
module NotificationsHelper

  # Method used to define notification options
  # @return [Map]
  def notifications_options
    I18n.t(:notifications_options).map { |key, value| [value, key] }
  end

  # Method used to check if the listing for notifications is a mini version
  # @return [Boolean] Returns true if the listing is Mini
  def mini_listing?
    params[:referer] == REFERERS[:mini_activity_listing]
  end

  # Method Used to Return Notification Created Time in a Specific String Word Format
  # @return [String] Returns String for Notification Creation
  def notification_created_time
    time_ago_in_words(@activity.created_at).gsub(/about|less than|almost|over/, '').strip << ' ago'
  end
end