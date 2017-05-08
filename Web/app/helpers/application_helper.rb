module ApplicationHelper
  include NotificationsHelper

  def page_title(title)
    @page_title = title
    content_tag(:h1, @page_title, class: ['font-light'])
  end

  def header_title(title)
    @page_title = title
    content_tag(:title, @page_title + ' - PairCon')
  end

  def render_flash_message
    render 'layouts/flash_message'
  end

  def main_title(title)
    @main_title = title
  end

  def locale_setting_js
    javascript_tag("I18n.defaultLocale='#{I18n.default_locale}';I18n.locale='#{I18n.locale}';")
  end

  def time_zone_setting_js
    javascript_tag('$(function(){try{document.cookie="time_zone_name="+getTimezoneName();document.cookie="gmt_offset_minutes="+ -1*(new Date).getTimezoneOffset();}catch(e){}});')
  end

  def icon_text(icon_name, text = '')
    content_tag(:i, nil, :class => "fa fa-fw fa-#{icon_name.to_s}") + " " + content_tag(:span, text.html_safe)
  end

  def link_to_modal(name, link_to_remote_options = {}, html_options = {})
    html_options.merge!({data: {toggle: 'modal', target: '#modal', backdrop: 'static'}})
    link_to(name, link_to_remote_options, html_options)
  end

  def init_error_flash_for_login()
    flash_errors = [flash[:error], flash[:alert], flash[:notice]]
    flash_errors = flash_errors + resource.errors.full_messages if defined? resource
    flash_errors.compact!
    flash[:alert] = flash_errors.join('<br />') unless flash_errors.blank?
  end

  def init_error_flash()
    flash_errors = [flash[:error], flash[:alert]]
    flash_errors = flash_errors + resource.errors.full_messages if defined? resource
    flash_errors.compact!
    flash[:alert] = flash_errors.join('<br />') unless flash_errors.blank?
  end

end
