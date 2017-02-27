class User::RegistrationController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_url()
  end
end