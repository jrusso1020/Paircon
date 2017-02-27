class HomeController < ApplicationController
  # before_filter :authenticate_user!
  before_action :reroute

  def index
  end

  def about
    @page_title = 'About'
    render layout: 'home/about', layout: false
  end

  def features
    @page_title = 'Features'
    render layout: 'home/features', layout: false
  end

  def reroute
    if user_signed_in?
      # re route to app
    end
  end
end
