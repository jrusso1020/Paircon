# Controller primarily responsible for handling Errors
class ErrorsController < ApplicationController

  # Action used to handle a Not Found (404) Error
  def not_found
    render status: 404, layout: signed_in?(:user) ? 'application' : 'error'
  end

  # Action used to handle an Internal Server (500) Error
  def internal_server_error
    render status: 500, layout: signed_in?(:user) ? 'application' : 'error'
  end

  # Action used to handle a Unauthorized Access (403) Error
  def unauthorized_access
    render status: 403, layout: signed_in?(:user) ? 'application' : 'error'
  end
end
