class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    
  end

  def privacy_policy
    render layout: 'home/privacy_policy'
  end

  def terms
    render layout: 'home/terms'
  end

end
