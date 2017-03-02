class HomeController < ApplicationController
  # before_filter :authenticate_user!
  before_action :reroute

  def index
  end

  def about
    render layout: 'home/about', layout: false
  end

  def features
    render layout: 'home/features', layout: false
  end

  def terms
    render layout: 'home/terms', layout: false
  end

  def privacy_policy
    render layout: 'home/privacy_policy', layout: false
  end

  def reroute
    if user_signed_in?
      # re route to app
    end
  end
end
