require 'digest/md5'
class SchedulesController < ApplicationController

  before_action :authenticate_user!, except: [:get_resources, :get_events]
  before_action :find_resource, only: [:delete_resource, :destroy_resource]
  before_action :find_event, only: [:delete_event, :destroy_event, :update_event]

  def new_resource
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
          eventColor: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Auditorium."
    else
      ConferenceResource.create!(
          conference_id: params[:conference_id],
          title: conference_resource_params[:title],
          parent_id: conference_resource_params[:parent_id],
          building: nil,
          eventColor: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Room."
    end

    redirect_back(fallback_location: root_path)

  end

  def new_event
    @conference = Conference.find_by_id(params[:conference_id])
    auditoriums = @conference.conference_resources.where(parent_id: nil).select(:title, :id).distinct().order(:title)
    @auditoriums = auditoriums.map { |obj| [obj.title, obj.id] }
    @rooms = [['No Room', 'No Room']]
    unless @auditoriums.blank?
      @rooms = @rooms + @conference.conference_resources.where(parent_id: auditoriums.first.id).select(:title, :id).distinct().order(:title).map { |obj| [obj.title, obj.id] }
    end

    @start_date = params[:start_date].blank? ? '' : DateTime.parse(params[:start_date]).strftime(DATEFORMAT)
    @end_date = params[:end_date].blank? ? '' : DateTime.parse(params[:end_date]).strftime(DATEFORMAT)

    if !params[:resource_id].blank?
      resource = ConferenceResource.find(params[:resource_id])
      if resource.parent_id.nil? or resource.parent_id.blank?
        @room_name = 'None'
        @auditorium_name = resource.title
      else
        @room_name = resource.title
        @auditorium_name = ConferenceResource.find(resource.parent_id).title
      end
    else
      @auditorium_name = ''
      @room_name = ''
    end

    render layout: false
  end

  def create_event
    conference_event_params = params.require(:event).permit!

    if !conference_event_params[:resource_room].blank? and conference_event_params[:resource_room] != 'No Room'
      resource_id = conference_event_params[:resource_room]
    else
      resource_id = conference_event_params[:resource_auditorium]
    end

    ConferenceEvent.create!(
        conference_id: params[:conference_id],
        conference_resource_id: resource_id,
        title: conference_event_params[:title],
        start_date: conference_event_params[:start_date],
        end_date: conference_event_params[:end_date],
        color: '#' + Digest::MD5.hexdigest(conference_event_params[:title])[0..5]
    )

    flash[:notice] = "You have successfully created '#{conference_event_params[:title]}' Event."

    redirect_back(fallback_location: root_path)
  end

  def edit_event
    @conference_event = ConferenceEvent.find(params[:id])
    @conference = @conference_event.conference
    auditoriums = @conference.conference_resources.where(parent_id: nil).select(:title, :id).distinct().order(:title)
    @auditoriums = auditoriums.map { |obj| [obj.title, obj.id] }
    @rooms = [['No Room', 'No Room']]
    unless @auditoriums.blank?
      @rooms = @rooms + @conference.conference_resources.where(parent_id: auditoriums.first.id).select(:title, :id).distinct().order(:title).map { |obj| [obj.title, obj.id] }
    end

    conference_resource = @conference_event.conference_resource
    if (conference_resource.parent_id.nil?)
      @room_name = 'None'
      @auditorium_name = conference_resource.title
    else
      @room_name = conference_resource.title
      @auditorium_name = ConferenceResource.where(id: conference_resource.parent_id).title
    end

    render layout: false
  end

  def update_event
    conference_event_params = params.require(:event).permit!
    unless params[:update_dates].blank?
      attributes = {start_date: conference_event_params[:start_date],
                    end_date: conference_event_params[:end_date],
                    conference_resource_id: conference_event_params[:resource_id] }
    else
      if !conference_event_params[:resource_room].blank? and conference_event_params[:resource_room] != 'No Room'
        resource_id = conference_event_params[:resource_room]
      else
        resource_id = conference_event_params[:resource_auditorium]
      end

      attributes = {conference_resource_id: resource_id,
                    title: conference_event_params[:title],
                    start_date: conference_event_params[:start_date],
                    end_date: conference_event_params[:end_date],
                    color: '#' + Digest::MD5.hexdigest(conference_event_params[:title])[0..5]}
    end

    if @event.update!(attributes)
      flash[:notice] = "You have successfully updated '#{@event.title}'."
      status = :success
    else
      flash[:error] = "There was an error updating '#{@event.title}'. Please try again later"
      status = :error
    end

    unless params[:update_dates].blank?
      render json: {status: status, text: @event.title.nil? ? 'Event' : @event.title }
    else
      redirect_back(fallback_location: root_path)
    end

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

  def get_resources
    @conference = Conference.find(params[:id])
    resources = @conference.conference_resources.where(parent_id: nil).order(:title).map { |obj| {id: obj.id, title: obj.title, building: obj.building, eventColor: obj.eventColor} }

    if resources.length == 0
      sample_resource = [{id: 'a', building: 'Sample Building', title: 'Sample Auditorium', children: [{id: 'a1', title: 'Sample Room A'}, {id: 'a2', title: 'Sample Room B'}]}]
      render json: sample_resource.to_json
    else
      rooms = @conference.conference_resources.where.not(parent_id: nil).order(:title)

      rooms.each do |room|
        auditorium = resources.find { |x| x[:id] == room.parent_id }
        auditorium[:children] = [] if auditorium[:children].nil?
        auditorium[:children] = auditorium[:children] + [{id: room.id, title: room.title, eventColor: room.eventColor}]
      end

      render json: resources.to_json
    end

  end

  def get_events
    @conference = Conference.find(params[:id])
    resources = @conference.conference_resources
    events = @conference.conference_events.order(:title).map { |obj| {id: obj.id, resourceId: obj.conference_resource_id, title: obj.title, start: obj.start_date.to_time.iso8601, end: obj.end_date.to_time.iso8601, color: obj.color} }

    if events.length == 0 and resources.length == 0
      sample_events = [
          {id: '1', resourceId: 'a1', start: @conference.start_date.iso8601.to_s, end: (@conference.start_date + 2.hours).to_time.iso8601.to_s, title: 'Sample Event 1', color: 'Red'},
          {id: '2', resourceId: 'a2', start: (@conference.start_date + 1.hours).to_time.iso8601.to_s, end: (@conference.start_date + 12.hours).to_time.iso8601.to_s, title: 'Sample Event 2', color: 'Blue'},
      ]

      render json: sample_events.to_json
    else
      render json: events.to_json
    end

  end

  def get_events_user

    @current_user = User.get_by_id(params[:id])
    Rails.logger.debug("User Object Id: ${@current_user.inspect}")
    @conference = Conference.my_attending_conferences_active(@current_user)
    Rails.logger.debug("User Object Id: ${@conference.inspect}")

    resources = @conference.conference_resources
    events = @conference.conference_events.order(:title).map { |obj| {id: obj.id, resourceId: obj.conference_resource_id, title: obj.title, start: obj.start_date.to_time.iso8601, end: obj.end_date.to_time.iso8601, color: obj.color} }

    render json: events.to_json


  end

  def get_rooms
    rooms = [{text: 'No Room', value: 'No Room'}] + ConferenceResource.where(parent_id: params[:id]).select(:title, :id).distinct().order(:title).map { |obj| {text: obj.title, value: obj.id} }
    render json: rooms.to_json
  end

  private

  def find_conference
  end

  def find_resource
    @resource = ConferenceResource.find(params[:id])
  end

  def find_event
    @event = ConferenceEvent.find(params[:id])
  end
end