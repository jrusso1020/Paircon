class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
  end

  # show static page
  def show
    render params[:page]
  end
  
end
