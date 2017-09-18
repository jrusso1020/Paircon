Devise.setup do |config|

  config.secret_key = '7d0c66485f217f2749d67f36638888f1631b8314dcddebefb75fe1d520ddcc07e185a64bb3ef3b61b1c61438230cfd54e56782d280659c3fca6ded5218f4fefc'

  config.mailer = 'Notifier'

  require 'devise/orm/active_record'
  require 'paircon_config'

  config.authentication_keys = [:email]
  config.case_insensitive_keys = [:email]
  # config.token_authentication_key = :auth_token
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth, :token_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.timeout_in = 720.minutes
  config.allow_unconfirmed_access_for = 720.days

  config.omniauth :google_oauth2, PairconConfig.google_settings[:client_id],
                  PairconConfig.google_settings[:client_secret], {
                      approval_prompt: 'force',
                      scope: GOOGLE_OAUTH2_SCOPE,
                      name: 'google_oauth2',
                      access_type: 'offline'
                  }

  config.omniauth :facebook, (Rails.env == 'development' || Rails.env == 'test') ? PairconConfig.facebook_settings[:app_id] : PairconConfig.facebook_settings_production[:app_id],
                  (Rails.env == 'development' || Rails.env == 'test') ? PairconConfig.facebook_settings[:app_secret] : PairconConfig.facebook_settings_production[:app_secret], {
                      approval_prompt: 'force',
                      name: 'facebook',
                      access_type: 'offline'
                  }

  config.warden do |manager|
    require 'devise/custom_failure'
    manager.failure_app = CustomFailure
  end
end
