require 'omniauth'

module OmniAuth
  module Strategies
    class HoneyBadger
      include OmniAuth::Strategy

      args [:authentication_url]

      def request_phase
        response = Rack::Response.new
        response.redirect "#{options.authentication_url}?redir=#{full_host + script_name + callback_path}"
        response.finish
      end

      def callback_phase
        request = Rack::Request.new env
        cookies = request.cookies
        response = Rack::Response.new

        if cookies['honey_badger'] != nil
          # code to set a devise/warden or some other local login session
          response.redirect some_application_url
          response.finish
        else
          response.status = 401
          response.finish
        end
      end
    end
  end
end