# Controller handling Sessions From Devise (Extension)
class Users::SessionsController < Devise::SessionsController
  # Default layout
  layout 'home'

  # Function handling making a new devise session
  def new
    super
  end

  # Function handling successful creation of session
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
end