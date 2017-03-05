module OmniAuth
  module Strategies
    class GoogleOauth2 < OmniAuth::Strategies::OAuth2
      option :authorize_options, [:scope, :redirect_uri, :approval_prompt, :access_type, :state, :hd]
    end
  end
end

if RUBY_VERSION == '2.1.2'
  module HTTPResponseDecodeContentOverride
    def initialize(h,c,m)
      super(h,c,m)
      @decode_content = true
    end

    def body
      res = super
      self['content-length'] = res.bytesize if res.respond_to?(:bytesize) && self['content-length']

      res
    end
  end

  module Net
    class HTTPResponse
      prepend HTTPResponseDecodeContentOverride
    end
  end
end