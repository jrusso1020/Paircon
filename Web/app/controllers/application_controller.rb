class ApplicationController < ActionController::Base
  include ActiveDevice

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  layout :layout_by_resource

  helper_method :current_page, :log
  helper :all

  def log(data)
    Rails.logger.debug("\n\n==========LOG============\n\n#{data}\n\n=======================\n\n")
  end

  def not_found
    render file: NOT_FOUND_404, formats: [:html], layout: false, status: 404
  end

  def layout_by_resource
    unless request.headers['X-PJAX']

      if request.xhr?
        false
      else
        # if devise_controller?
        #   if resource_name == :user
        #     'login'
        #   end
        # elsif request.path =~ /\/oauth2/i
        #   'login'
        # else
          'application'
        # end
      end
    else
      response.headers['X-PJAX-Version'] = "v123"
      false
    end
  end



end
