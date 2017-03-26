class ConferencesController < ApplicationController
  before_action :find_conference, only: [:edit, :update, :show, :delete]
  before_action :authenticate_user!, except: [:validation]
  before_action :check_session, :only => [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def set_user
    @user = current_user
  end

  def check_session
    redirect_to root_path unless current_user
  end

  # Index action to render all conferences
  def index
    conference_ids  = ConferenceOrganizer.where(user_id: current_user.id).uniq.pluck(:conference_id)
    arr = Array.new
    conference_ids.each do |conference_id|
      if conference_id == nil
        next
      end
      arr.push(Conference.find(conference_id))
    end
    @conferences = arr
  end

  # New action for creating conference
  def new
    @conference = Conference.new
  end

  # Create action saves the conference into database
  def create
    @conference = Conference.new(conference_params)
    print @conference.id
    if @conference.save
      @conferenceOrganizer = ConferenceOrganizer.new(:conference_id => @conference.id, :user_id => current_user.id)
      if @conferenceOrganizer.save
        flash[:notice] = "Successfully created conference!"
        redirect_to conference_path(@conference)
      else
        flash[:alert] = "Error creating new conference!"
        render :new
      end
    else
      flash[:alert] = "Error creating new conference!"
      render :new
    end

  end

  # Edit action retrives the conference and renders the edit page
  def edit
  end

  # Update action updates the conference with the new information
  def update
    if @conference.update_attributes(conference_params)
      flash[:notice] = "Successfully updated conference!"
      redirect_to conference_path(@conference)
    else
      flash[:alert] = "Error updating conference!"
      render :edit
    end
  end

  # The show action renders the individual conference after retrieving the the id
  def show
  end

  # The destroy action removes the conference permanently from the database
  def destroy
    if @conference.destroy and @conferenceOrganizer.destroy
      flash[:notice] = "Successfully deleted conference!"
      redirect_to conference_path
    else
      flash[:alert] = "Error updating conference!"
    end
  end

  private

  def conference_params
    params.require(:conference).permit(:name, :start_date, :end_date, :url, :location)
  end

  def find_conference
    @conference = Conference.find(params[:id])
  end
end
