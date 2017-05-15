class PairConConfig
  class << self

    # Loads Local Settings in Global Variable
    # @return [String] as Global Variable @@local_settings
    def local_settings()
      @@local_settings ||= YAML.load_file("#{Rails.root}/config/local_settings.yml")
    end

    # Get Root Domain
    # @return [String] Return root domain from local settings file
    def root_domain
      if Rails.env.development?
        root_domain = local_settings['development_environment']
      else
        root_domain = local_settings['production_environment']
      end
      root_domain
    end

    # Get Recommendation System Domain
    # @return [String] Return Recommendation System domain from local settings file
    def recommendation_system_domain
      if Rails.env.development?
        recommendation_system_domain = local_settings['machine_learning_development_api_url']
      else
        recommendation_system_domain = local_settings['machine_learning_production_api_url']
      end
      recommendation_system_domain
    end

    # Get Product Name
    # @return [String] Return Product Name from local settings file
    def product_name
      local_settings['product_name']
    end

    # Get Support Email
    # @return [String] Return Support Email from local settings file
    def support_email
      local_settings['support_email']
    end

    # Get Contact Us Recipients
    # @return [String] Return Contact Us Recipients from local settings file
    def contact_us_recipients
      local_settings['contact_us_recipients']
    end

    # Get Exception Recipients
    # @return [String] Return Exception Recipients from local settings file
    def exception_recipients
      local_settings['exception_recipients']
    end

    # Get Email Prefix
    # @return [String] Return Email Prefix from local settings file
    def email_prefix
      local_settings['email_prefix']
    end

    # Get Exception Sender
    # @return [String] Return Exception Sender from local settings file
    def exception_sender
      local_settings['exception_sender']
    end

    # Get Product URL
    # @return [String] Return Product URL from local settings file
    def product_url
      local_settings['product_url']
    end

    # Get No Reply Email
    # @return [String] Return No Reply Email from local settings file
    def noreply_email
      local_settings['noreply_email']
    end

    # Get Marketing Email
    # @return [String] Return Marketing Email from local settings file
    def marketing_email
      local_settings['marketing_email']
    end

    # Get Facebook Settings [Development]
    # @return [Map] Return Facebook Settings from local settings file
    def facebook_settings
      {
          app_id: local_settings['facebook_app_id'],
          app_secret: local_settings['facebook_app_secret']
      }
    end

    # Get Facebook Settings [Production]
    # @return [Map] Return Facebook Settings from local settings file
    def facebook_settings_production
      {
          app_id: local_settings['production_facebook_app_id'],
          app_secret: local_settings['production_facebook_app_secret']
      }
    end

    # Get Google Settings
    # @return [Map] Return Google Settings from local settings file
    def google_settings
      {
          client_id: local_settings['google_api_client_id'],
          client_secret: local_settings['google_api_client_secret']
      }
    end

    # Get Google Map API Key
    # @return [String] Google Map API Key
    def google_api_key
      local_settings['google_map_api_key']
    end

    # Get Email Server Settings
    # @return [Map] Return Email Settings from local settings file
    def mail_settings
      {
          address: local_settings['mail_address'],
          port: local_settings['mail_port'],
          domain: local_settings['mail_domain'],
          username: local_settings['mail_username'],
          password: local_settings['mail_password']
      }
    end

    # Get Misc URLs
    # @return [Map] Return Misc URLs from local settings file
    def url
      {
          help: local_settings['help_url'],
          support: local_settings['support_url']
      }
    end

  end
end
