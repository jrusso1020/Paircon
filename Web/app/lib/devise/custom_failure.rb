class CustomFailure < Devise::FailureApp
  def redirect_url
    #return super unless [:worker, :employer, :user].include?(scope) #make it specific to a scope
    
    if scope == :user
      new_user_session_url(anchor: 'main-header')
    else
      new_siteadmin_session_url(subdomain: RESERVED_SUBDOMAIN)
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end