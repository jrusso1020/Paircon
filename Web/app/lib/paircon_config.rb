class PairConConfig
  class << self
    def local_settings()
      @@local_settings ||= YAML.load_file("#{Rails.root}/config/local_settings.yml")
    end

    def root_domain
      if Rails.env.development?
        root_domain = local_settings['development_environment']
      else
        root_domain = local_settings['production_environment']
      end
      root_domain
    end

    def recommendation_system_domain
      if Rails.env.development?
        recommendation_system_domain = local_settings['machine_learning_development_api_url']
      else
        recommendation_system_domain = local_settings['machine_learning_production_api_url']
      end
      recommendation_system_domain
    end

    def product_name
      local_settings['product_name']
    end
    
    def support_email
      local_settings['support_email']
    end
    
    def contact_us_recipients
      local_settings['contact_us_recipients']
    end
    
    def exception_recipients
      local_settings['exception_recipients']
    end
    
    def email_prefix
      local_settings['email_prefix']
    end
    
    def exception_sender
      local_settings['exception_sender']
    end
    
    def product_url
      local_settings['product_url']
    end
    
    def noreply_email
      local_settings['noreply_email']
    end
    
    def marketing_email
      local_settings['marketing_email']
    end
    
    def facebook_settings
      {
          app_id: local_settings['facebook_app_id'],
          app_secret: local_settings['facebook_app_secret']
      }
    end

    def google_settings
      {
        client_id: local_settings['google_api_client_id'],
        client_secret: local_settings['google_api_client_secret']
      }
    end

    def google_api_key
      local_settings['google_map_api_key']
    end

    def mail_settings
      {
          address: local_settings['mail_address'],
          port: local_settings['mail_port'],
          domain: local_settings['mail_domain'],
          username: local_settings['mail_username'],
          password: local_settings['mail_password']
      }
    end

    def url
      {
          privacy: local_settings['privacy_url'],
          terms: local_settings['terms_url'],
          help: local_settings['help_url'],
          support: local_settings['support_url']
      }
    end
    
  end
end
