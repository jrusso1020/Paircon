class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:home, :search]

  def index
  end

  def privacy_policy
    render layout: false
  end

  def terms
    render layout: false
  end

  def search
    query = params[:search_val]
    @conferences = []
    @conferences += Conference.where("name like ?", "%#{query}%")
    @conferences += Conference.where("location like ?", "%#{query}%")
    @conferences += Conference.where("domain like ?", "%#{query}%")

    render :search_results
  end

end
