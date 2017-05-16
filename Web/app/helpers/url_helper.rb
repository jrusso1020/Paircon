# Helper primarily responsible for URLs
module UrlHelper

  # Method used to check add a subdomain
  # @param subdomain [String] Subdomain to be added
  # @return [String] Join the subdomain with the request domain and port string
  def with_subdomain(subdomain)
    subdomain = (subdomain || '')
    subdomain += '.' unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join
  end

  # Method used to if the url is for the specified options
  # @param options [Map] Options Map
  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end
end

