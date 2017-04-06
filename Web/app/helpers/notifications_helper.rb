module NotificationsHelper

  def notifications_options
    I18n.t(:notifications_options).map { |key, value| [value, key] }
  end

  def mini_listing?
    params[:referer] == REFERERS[:mini_activity_listing]
  end

  def notification_owner_name(email = nil)
    " #{@activity.owner.try(:first_name) || email} ".html_safe
  end

  def notification_created_time
    time_ago_in_words(@activity.created_at).gsub(/about|less than|almost|over/, '').strip << ' ago'
  end

  def notification_header(heading, icon_name = 'briefcase')
    if mini_listing?()
      content_tag(:span, notification_created_time(), :class => 'time') +
          content_tag(:i, '', :class => "fa fa-#{icon_name} fa-large") + content_tag(:span, heading, :class => 'name')
    else
      content_tag(:i, '', :class => "fa fa-#{icon_name} fa-large") + "&nbsp;".html_safe
    end
  end

  def notification_footer
    return "" if mini_listing?()
    content_tag(:span, "&nbsp;&nbsp;#{notification_created_time()}".html_safe, :class => 'text-muted')
  end
end