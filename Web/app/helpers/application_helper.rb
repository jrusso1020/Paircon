# Helper primarily responsible for providing application wide Utils
module ApplicationHelper
  include NotificationsHelper

  # Creates a Page Title With <H1>
  # @param title [String] String to create a Tag for
  # @return
  def page_title(title)
    @page_title = title
    content_tag(:h1, @page_title, class: ['font-light'])
  end

  # Creates a Page Title for Browser
  # @param title [String] String to create a Tag for
  def header_title(title)
    @page_title = title
    content_tag(:title, @page_title + ' - PairCon')
  end

  # Creates a jS Setting for Locale
  def locale_setting_js
    javascript_tag("I18n.defaultLocale='#{I18n.default_locale}';I18n.locale='#{I18n.locale}';")
  end

  # Creates a jS Setting for Time zone
  def time_zone_setting_js
    javascript_tag('$(function(){try{document.cookie="time_zone_name="+getTimezoneName();document.cookie="gmt_offset_minutes="+ -1*(new Date).getTimezoneOffset();}catch(e){}});')
  end

  # Creates a Font Awesome icon with text
  # @param icon_name [String] Name of the Font Awesome Icon
  # @param text [String] Required String
  def icon_text(icon_name, text = '')
    content_tag(:i, nil, :class => "fa fa-fw fa-#{icon_name.to_s}") + " " + content_tag(:span, text.html_safe)
  end

  # Creates a Link That opens a Modal
  # @param name [String] The name for the link
  # @param link_to_remote_options [Hash] Any Remote Options for Modal
  # @param html_options [Hash] Any HTML Options
  def link_to_modal(name, link_to_remote_options = {}, html_options = {})
    html_options.merge!({data: {toggle: 'modal', target: '#modal', backdrop: 'static'}})
    link_to(name, link_to_remote_options, html_options)
  end

  # Initializes error flash on login
  def init_error_flash_for_login()
    flash_errors = [flash[:error], flash[:alert], flash[:notice]]
    flash_errors = flash_errors + resource.errors.full_messages if defined? resource
    flash_errors.compact!
    flash[:alert] = flash_errors.join('<br />') unless flash_errors.blank?
  end

  # Initializes error flash after logging in
  def init_error_flash()
    flash_errors = [flash[:error], flash[:alert]]
    flash_errors = flash_errors + resource.errors.full_messages if defined? resource
    flash_errors.compact!
    flash[:alert] = flash_errors.join('<br />') unless flash_errors.blank?
  end

end
