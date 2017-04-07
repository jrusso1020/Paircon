require 'digest/md5'
class SchedulesController < ApplicationController
  before_action :authenticate_user!, except: [:validation]
  before_action :find_resource, only: [:delete_resource, :destroy_resource]
  before_action :find_event, only: [:delete_event, :destroy_event]

  def get_resource
    if params[:view] == ConferenceResource::TYPE[:auditorium]
      @title = 'Add Auditorium'
      @body = 'Please enter the name of the Auditorium and select the Building. You can define an Auditorium without a building.'
      @buildings = [['None', 'None'], ['Other', 'Other']] + Conference.find_by_id(params[:conference_id]).conference_resources.select(:building).distinct().map { |obj| [obj.building, obj.building] }
    else
      @title = 'Add Room'
      @body = 'Please enter the name of the Room you want to add and select the Auditorium to which it belongs.'
      @auditoriums = Conference.find_by_id(params[:conference_id]).conference_resources.select(:title, :id).distinct().map { |obj| [obj.title, obj.id] }
    end

    render layout: false
  end

  def create_resource
    conference_resource_params = params.require(:resource).permit!

    if params[:view] == ConferenceResource::TYPE[:auditorium]
      ConferenceResource.create!(
          conference_id: params[:conference_id],
          title: conference_resource_params[:title],
          parent_id: nil,
          building: conference_resource_params[:building] != 'Other' ? conference_resource_params[:building] : conference_resource_params[:building_other],
          eventColor: Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Auditorium."
    else
      ConferenceResource.create!(
          conference_id: params[:conference_id],
          title: conference_resource_params[:title],
          parent_id: conference_resource_params[:parent_id],
          building: nil,
          eventColor: Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Room."
    end

    redirect_back(fallback_location: root_path)

  end

  def get_event
    render layout: false
  end

  def create_event
    redirect_back(fallback_location: root_path)
  end

  def delete_resource
    render layout: false
  end

  def delete_event
    render layout: false
  end

  def destroy_resource
    ConferenceResource.transaction do
      ConferenceResource.where(parent_id: @resource.id).destroy_all

      name = @resource.title

      if @resource.destroy
        flash[:notice] = "Successfully deleted '" + name + "'."
      else
        flash[:error] = "Unable to delete '" + name + "' due to some error. Please try again later ..."
      end
    end

    redirect_back(fallback_location: root_path)
  end


  def destroy_event
    ConferenceEvent.transaction do
      name = @event.title

      if @event.destroy
        flash[:notice] = "Successfully deleted '" + name + "'."
      else
        flash[:error] = "Unable to delete '" + name + "' due to some error. Please try again later ..."
      end
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def find_resource
    @resource = ConferenceResource.find(params[:id])
  end

  def find_event
    @resource = ConferenceEvent.find(params[:id])
  end
end