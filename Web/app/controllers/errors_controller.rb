class ErrorsController < ApplicationController
  def not_found
    render status: 404, layout: signed_in?(:user) ? 'application' : 'error'
  end

  def internal_server_error
    render status: 500, layout: signed_in?(:user) ? 'application' : 'error'
  end

  def unauthorized_access
    render status: 403, layout: signed_in?(:user) ? 'application' : 'error'
  end
end
