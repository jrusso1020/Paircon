require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PairCon
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    local_settings = YAML.load_file("#{Rails.root}/config/local_settings.yml")

    # Custom directories with classes and modules you want to be auto loadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Configure the default encoding used in templates for Ruby
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.time_zone = 'UTC'
    config.log_level = :debug

    config.active_job.queue_adapter = :sidekiq

    config.before_initialize do
      require File.join(Rails.root, 'config', 'paircon_constants.rb')
    end

    config.middleware.insert_before Warden::Manager, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
      end
    end

    # Mailer Settings
    config.active_record.raise_in_transactional_callbacks = true
    config.action_mailer.raise_delivery_errors = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address => local_settings['mail_address'],
        :port => local_settings['mail_port'],
        :domain => local_settings['mail_domain'],
        :authentication => :plain,
        :user_name => local_settings['mail_username'],
        :password => local_settings['mail_password'],
        :enable_starttls_auto => true,
        :openssl_verify_mode => 'none'
    }

    config.i18n.enforce_available_locales = false
  end
end
