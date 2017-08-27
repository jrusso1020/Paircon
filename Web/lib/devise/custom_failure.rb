# This library handles Custom Failures
class CustomFailure < Devise::FailureApp

  # Method handles URL redirection
  # @return [HTML] Redirects to URL if the scope is user or admin
  def redirect_url
    #return super unless [:worker, :employer, :user].include?(scope) #make it specific to a scope
    
    if scope == :user
      new_user_session_url(anchor: 'main-header')
    else
      new_siteadmin_session_url(subdomain: RESERVED_SUBDOMAIN)
    end
  end

  # Method executed on Responding of failure
  # @return [HTML]
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end