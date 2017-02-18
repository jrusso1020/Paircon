require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NextLec
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    PRODUCTION_HOSTNAME = "localhost"

    MAIL_ADDRESS = ""
    MAIL_PORT = 587
    MAIL_DOMAIN = ""
    MAIL_USERNAME = ""
    MAIL_PASSWORD = ""

    # Custom directories with classes and modules you want to be auto loadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Configure the default encoding used in templates for Ruby
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.time_zone = "UTC"
    config.log_level = :debug

    config.before_initialize do
      require File.join(Rails.root, 'config', 'constants.rb')
    end

    # Mailer Settings
    config.active_record.raise_in_transactional_callbacks = true
    config.action_mailer.raise_delivery_errors = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address => MAIL_ADDRESS,
        :port => MAIL_PORT,
        :domain => MAIL_DOMAIN,
        :authentication => :plain,
        :user_name => MAIL_USERNAME,
        :password => MAIL_PASSWORD,
        :enable_starttls_auto => true,
        :openssl_verify_mode => "none"
    }


  end
end
