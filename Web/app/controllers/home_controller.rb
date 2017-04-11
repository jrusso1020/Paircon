class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
  end

  def privacy_policy
    render layout: false
  end

  def terms
    render layout: false
  end

end
