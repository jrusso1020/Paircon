# This Controller is used to handle Social Media Authentication Callbacks
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Function executed on successful callback
  # @param [Object] provider the name of provider
  # @return [HTML] Redirects New User Registration URL
  def self.provides_callback_for(provider)
    define_method provider do
      auth = env['omniauth.auth']
      @user = IdentifierService.new(auth, current_user).resolve

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
      else
        session["devise.#{provider}_data"] = auth
        redirect_to new_user_registration_url
      end
    end
  end

  [:google_oauth2, :facebook].each { |provider| provides_callback_for provider }

  # Function executed on failure
  # @return [HTML] Redirects New User Session URL
  def failure
    flash[:error] = 'Unable to continue as access has been denied.'
    redirect_to new_user_session_path and return
  end

end