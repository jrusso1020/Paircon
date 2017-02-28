class HomeController < ApplicationController
  # before_filter :authenticate_user!
  before_action :reroute

  def index
    @page_title = 'Home'
  end

  def about
    @page_title = 'About'
    render layout: 'home/about', layout: false
  end

  def features
    @page_title = 'Features'
    render layout: 'home/features', layout: false
  end

  def terms
    @page_title = 'Terms'
    render layout: 'home/terms', layout: false
  end

  def privacy_policy
    @page_title = 'Privacy Policy'
    render layout: 'home/privacy_policy', layout: false
  end

  def reroute
    if user_signed_in?
      # re route to app
    end
  end
end
