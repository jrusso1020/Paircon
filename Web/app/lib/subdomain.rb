# Library used to handle Subdomain Utilities
class Subdomain

  # Method to check if the request has a subdomain and is not www
  # @param request [Request] Ruby HTTP Request Object
  # @return [boolean] True if a subdomain is present and not www
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != "www"
    true
  end
end