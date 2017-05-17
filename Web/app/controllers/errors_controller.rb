# Controller primarily responsible for handling Errors
class ErrorsController < ApplicationController

  # Action used to handle a Not Found (404) Error
  # @return [HTML] Renders Not Found View
  def not_found
    render status: 404, layout: user_signed_in? ? 'application' : 'error'
  end

  # Action used to handle an Internal Server (500) Error
  # @return [HTML] Renders Internal Server Error View
  def internal_server_error
    render status: 500, layout: user_signed_in? ? 'application' : 'error'
  end

  # Action used to handle a Unauthorized Access (403) Error
  # @return [HTML] Renders Unauthorized Access View
  def unauthorized_access
    render status: 403, layout: user_signed_in? ? 'application' : 'error'
  end
end
