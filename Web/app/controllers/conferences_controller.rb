class ConferencesController < ApplicationController
  before_action :find_conference, only: [:edit, :update, :show, :delete]
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # New action for creating conference
  def new
    render layout: false
  end

  # Create action saves the conference into database
  def create
    @conference = Conference.new()
    print @conference.id
    if @conference.save
      @conferenceOrganizer = ConferenceOrganizer.new(:conference_id => @conference.id, :user_id => current_user.id)
      if @conferenceOrganizer.save
        flash[:notice] = "We have created your Conference! Now edit the template before publishing it!"
        redirect_to conference_path(@conference)
      else
        flash[:alert] = "Error creating your Conference! Please contact our support team."
        redirect :back
      end
    else
      flash[:alert] = "Error creating your Conference! Please contact our support team."
      redirect :back
    end

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

  def set_user
    @user = current_user
  end

  def conference_params
    params.require(:conference).permit(:name, :start_date, :end_date, :url, :location)
  end

  def find_conference
    @conference = Conference.find(params[:id])
  end
end
