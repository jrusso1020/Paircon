class ApplicationController < ActionController::Base
  include UrlHelper
  include ActiveDevice

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  layout :layout_by_resource, except: [:about, :features]

  helper_method :current_page, :log
  helper :all

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :is_app_init_for_sign_up
  before_action :set_mailer_url_options
  before_action :set_cache_buster
  before_action :load_left_column
  skip_before_action :set_mobile_format

  etag { current_user.try :id }

  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] =' "Fri, 01 Jan 1990 00:00:00 GMT"'
  end

  def log(data)
    Rails.logger.debug("\n\n==========LOG============\n\n#{data}\n\n=======================\n\n")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit({roles: []}, :email, :password, :password_confirmation, :first_name, :last_name) }
  end

  def not_found
    render file: '/errors/internal_server_error', formats: [:html], layout: false, status: 404
  end

  def layout_by_resource
    unless request.headers['X-PJAX']

      if request.xhr?
        false
      else
        if devise_controller?
          if resource_name == :user
            'home'
          end
        elsif request.path =~ /\/oauth2/i
          'home'
        else
          'application'
        end
      end
    else
      response.headers['X-PJAX-Version'] = 'v123'
      false
    end
  end

  private

  def load_left_column
    if signed_in?(:user)
      @attending_conferences = Conference.my_attending_conferences(current_user)

      unless current_user.attendee?
        @organizing_conferences = Conference.my_organizing_conferences(current_user)
      end

    end
  end

  def layout
    request.xhr? ? false : 'application'
  end

  def current_page
    "#{params[:controller]}_#{params[:action]}"
  end

  def set_locale
    if !params[:lang].blank?
      I18n.locale = params[:lang]
    elsif !current_user.nil?
      I18n.locale = current_user.default_lang
    else
      I18n.locale = 'en'
    end
  end

  def set_timezone
    if !signed_in?(:user)
      Time.zone = find_timezone()
    elsif !current_user.time_zone_name.nil?
      Time.zone = ActiveSupport::TimeZone[current_user.time_zone_name]
    end
  end

  def find_timezone
    time_zone = ActiveSupport::TimeZone[cookies[:time_zone_name]] unless cookies[:time_zone_name].blank?

    if time_zone.nil?
      unless cookies[:gmt_offset_minutes].blank?
        gmt_offset_seconds = cookies[:gmt_offset_minutes].to_i.minutes
        time_zone = ActiveSupport::TimeZone[gmt_offset_seconds]
      end

      time_zone = ActiveSupport::TimeZone['UTC'] if time_zone.nil?
      cookies[:time_zone_name] = time_zone.name
    end

    time_zone
  end

  def save_timezone!
    timezone = find_timezone()
    current_user.time_zone_name = timezone.name
    current_user.save!(validate: false)
  end

  # Overwriting the sign_in redirect path method
  def after_sign_in_path_for(resource_or_scope)
    save_timezone!() if current_user.time_zone_name.blank?
    stored_location_for(resource_or_scope) || dashboard_path()
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_url()
  end

  def is_app_init_for_sign_up
    ActiveRecord::Base.skip_callbacks = false

    # session[:backlink] = nil if params[:action] != "files" && params[:action] != "update_flags"

    if current_user && !current_user.is_app_init && !devise_controller? &&
        params[:action] != 'save_logo' && params[:action] != 'destroy_logo' && params[:action] != 'validation'

      if current_page == 'users_edit' || current_page == 'users_update'
        params[:referer] = REFERERS[:app_init]
      else
        redirect_to edit_user_path(id: current_user, referer: REFERERS[:app_init]) and return
      end
    end
  end

  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomain)
  end

end
