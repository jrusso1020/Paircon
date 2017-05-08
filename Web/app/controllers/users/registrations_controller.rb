# Controller handling Registrations From Devise (Extension)
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Function executed on being inactive
  def after_inactive_sign_up_path_for(resource)
    new_user_session_url()
  end
end