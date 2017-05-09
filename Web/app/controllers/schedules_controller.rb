# Controller primarily responsible for handling Schedules
class SchedulesController < ApplicationController

  require 'digest/md5'

  before_action :authenticate_user!, except: [:get_resources, :get_events]
  before_action :find_resource, only: [:delete_resource, :destroy_resource]
  before_action :find_event, only: [:delete_event, :destroy_event, :update_event]

  # Action for showing modal for new resource creation
  def new_resource
    @conference = Conference.find_by_id(params[:conference_id])
    if params[:view] == ConferenceResource::TYPE[:event]
      @title = 'Add Event'
      @body = 'Please enter information about the Event you are hosting and add the name of the Room to which this Event belongs.'
      @rooms = [['Other', 'Other']] + @conference.conference_resources.select(:room).distinct().map { |obj| [obj.room, obj.room] }
    else
      @title = 'Add Session'
      @body = 'Please information about the Session along with the type of Session, name of Paper and the Event to which this Session belongs.'
      @events = @conference.conference_resources.select(:title, :id).distinct().where({:parent_id => nil}).map { |obj| [obj.title, obj.id] }
      papers = @conference.papers.select(:title, :id).order(:title)
      @papers = papers.map { |obj| [obj.title, obj.id] }
    end
    render layout: false
  end

  # Action for processing resource creation
  def create_resource
    conference_resource_params = params.require(:resource).permit!
    if conference_resource_params[:room] == 'Other'
      room_name = conference_resource_params[:room_other]
    elsif conference_resource_params[:room] == 'None'
      room_name = ''
    else
      room_name = conference_resource_params[:room]
    end

    if params[:view] == ConferenceResource::TYPE[:event]
      event_start_date = DateTime.parse(conference_resource_params[:date] + ' ' + conference_resource_params[:start_time])
      event_end_date = DateTime.parse(conference_resource_params[:date] + ' ' + conference_resource_params[:end_time])

      event_resource = ConferenceResource.create!(
          conference_id: params[:conference_id],
          title: conference_resource_params[:title],
          parent_id: nil,
          room: room_name,
          eventColor: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      #create the corresponding event for the event_resource
      ConferenceEvent.create!(
          conference_id: params[:conference_id],
          conference_resource_id: event_resource.id,
          title: conference_resource_params[:title],
          start_date: event_start_date,
          end_date: event_end_date,
          color: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Event."
    else
      event_date = ConferenceEvent.find_by_conference_resource_id(conference_resource_params[:parent_id]).start_date.to_date
      session_start_date = DateTime.parse(event_date.to_s + ' ' + conference_resource_params[:start_time])
      session_end_date = DateTime.parse(event_date.to_s + ' ' + conference_resource_params[:end_time])

      session_resource = ConferenceResource.create!(
          conference_id: params[:conference_id],
          title: conference_resource_params[:title],
          parent_id: conference_resource_params[:parent_id],
          room: nil,
          eventColor: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )

      ConferenceEvent.create!(
          conference_id: params[:conference_id],
          conference_resource_id: session_resource.id,
          title: conference_resource_params[:title],
          start_date: session_start_date,
          end_date: session_end_date,
          presenter: conference_resource_params[:presenter],
          event_type: conference_resource_params[:event_type].to_i,
          paper_id: conference_resource_params[:paper_id],
          color: '#' + Digest::MD5.hexdigest(conference_resource_params[:title])[0..5]
      )
      flash[:notice] = "You have successfully created '#{conference_resource_params[:title]}' Session."
    end

    redirect_back(fallback_location: root_path)
  end

  # def new_event
  #   @conference = Conference.find_by_id(params[:conference_id])
  #
  #   events = @conference.conference_resources.where(parent_id: nil).select(:title, :id).distinct().order(:title)
  #   @events = events.map { |obj| [obj.title, obj.id] }
  #   papers = @conference.papers.select(:title, :id).order(:title)
  #
  #   @papers = papers.map{|obj| [obj.title, obj.id]}
  #   @sessions = [['No Session', 'No Session']]
  #   unless @events.blank?
  #     @sessions = @sessions + @conference.conference_resources.where(parent_id: events.first.id).select(:title, :id).distinct().order(:title).map { |obj| [obj.title, obj.id] }
  #   end
  #
  #   @start_date = params[:start_date].blank? ? '' : DateTime.parse(params[:start_date]).strftime(DATETIMEFORMAT)
  #   @end_date = params[:end_date].blank? ? '' : DateTime.parse(params[:end_date]).strftime(DATETIMEFORMAT)
  #
  #   if !params[:resource_id].blank?
  #     resource = ConferenceResource.find(params[:resource_id])
  #     if resource.parent_id.nil? or resource.parent_id.blank?
  #       @session_name = 'None'
  #       @event_name = resource.title
  #     else
  #       @session_name = resource.title
  #       @event_name = ConferenceResource.find(resource.parent_id).title
  #     end
  #   else
  #     @event_name = ''
  #     @session_name = ''
  #   end
  #
  #   render layout: false
  # end
  #
  # def create_event
  #   conference_event_params = params.require(:event).permit!
  #
  #   if !conference_event_params[:resource_session].blank? and conference_event_params[:resource_session] != 'No session'
  #     resource_id = conference_event_params[:resource_session]
  #   else
  #     resource_id = conference_event_params[:resource_event]
  #   end
  #
  #   ConferenceEvent.create!(
  #       conference_id: params[:conference_id],
  #       conference_resource_id: resource_id,
  #       title: conference_event_params[:title],
  #       start_date: conference_event_params[:start_date],
  #       end_date: conference_event_params[:end_date],
  #       presenter: conference_event_params[:presenter],
  #       event_type: ConferenceEvent.event_types[conference_event_params[:event_type]],
  #       paper_id: conference_event_params[:paper_id],
  #       color: '#' + Digest::MD5.hexdigest(conference_event_params[:title])[0..5]
  #   )
  #
  #   flash[:notice] = "You have successfully created '#{conference_event_params[:title]}' Event."
  #
  #   redirect_back(fallback_location: root_path)
  # end
  #
  # def edit_event
  #   @conference_event = ConferenceEvent.find(params[:id])
  #   @conference = @conference_event.conference
  #   events = @conference.conference_resources.where(parent_id: nil).select(:title, :id).distinct().order(:title)
  #   @events = events.map { |obj| [obj.title, obj.id] }
  #   @sessions = [['No Session', 'No Session']]
  #   unless @events.blank?
  #     @sessions = @sessions + @conference.conference_resources.where(parent_id: events.first.id).select(:title, :id).distinct().order(:title).map { |obj| [obj.title, obj.id] }
  #   end
  #
  #   conference_resource = @conference_event.conference_resource
  #   if (conference_resource.parent_id.nil?)
  #     @session_name = 'None'
  #     @event_name = conference_resource.title
  #   else
  #     @session_name = conference_resource.title
  #     @event_name = ConferenceResource.where(id: conference_resource.parent_id).title
  #   end
  #
  #   render layout: false
  # end
  #
  # def update_event
  #   conference_event_params = params.require(:event).permit!
  #   unless params[:update_dates].blank?
  #     attributes = {start_date: conference_event_params[:start_date],
  #                   end_date: conference_event_params[:end_date],
  #                   conference_resource_id: conference_event_params[:resource_id]}
  #   else
  #     if !conference_event_params[:resource_session].blank? and conference_event_params[:resource_session] != 'No session'
  #       resource_id = conference_event_params[:resource_session]
  #     else
  #       resource_id = conference_event_params[:resource_event]
  #     end
  #
  #     attributes = {conference_resource_id: resource_id,
  #                   title: conference_event_params[:title],
  #                   start_date: conference_event_params[:start_date],
  #                   end_date: conference_event_params[:end_date],
  #                   presenter: conference_event_params[:presenter],
  #                   event_type: ConferenceEvent.event_types[conference_event_params[:event_type]],
  #                   paper_id: conference_event_params[:paper_id],
  #                   color: '#' + Digest::MD5.hexdigest(conference_event_params[:title])[0..5]}
  #   end
  #
  #   if @event.update!(attributes)
  #     flash[:notice] = "You have successfully updated '#{@event.title}'."
  #     status = :success
  #   else
  #     flash[:error] = "There was an error updating '#{@event.title}'. Please try again later"
  #     status = :error
  #   end
  #
  #   unless params[:update_dates].blank?
  #     render json: {status: status, text: @event.title.nil? ? 'Event' : @event.title}
  #   else
  #     redirect_back(fallback_location: root_path)
  #   end
  #
  # end

  # def delete_event
  #   render layout: false
  # end

  # Action for showing resource deletion modal
  def delete_resource
    render layout: false
  end

  # Action for processing and destroying ConferenceResource object
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

  # Action for processing and destroying ConferenceEvent object
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

  # Action used to provide json containing information about ConferenceResources [All]
  def get_resources
    @conference = Conference.find(params[:id])
    resources = @conference.conference_resources.where(parent_id: nil).order(:title).map { |obj| {id: obj.id, title: obj.title, room: obj.room, eventColor: obj.eventColor} }

    if resources.length == 0
      sample_resource = [{id: 'a', room: 'Sample Room', title: 'Sample Event', children: [{id: 'a1', title: 'Sample Session A'}, {id: 'a2', title: 'Sample Session B'}]}]
      render json: sample_resource.to_json
    else
      sessions = @conference.conference_resources.where.not(parent_id: nil).order(:title)

      sessions.each do |session|
        event = resources.find { |x| x[:id] == session.parent_id }
        event[:children] = [] if event[:children].nil?
        event[:children] = event[:children] + [{id: session.id, title: session.title, eventColor: session.eventColor}]
      end

      render json: resources.to_json
    end

  end

  # Action used to provide json containing information about ConferenceEvents
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

  # Action used to provide json containing information about ConferenceResources [All] With Respect to Signed in User
  def get_events_user
    events = []
    Conference.my_attending_conferences(current_user).published.each do |conference|
      events = events.push(*conference.conference_events.order(:title).map { |obj| {id: obj.id, resourceId: obj.conference_resource_id, title: obj.title, start: obj.start_date.to_time.iso8601, end: obj.end_date.to_time.iso8601, color: obj.color} })
    end

    render json: events.to_json
  end

  # Action used to provide json containing information about ConferenceResource [Session]
  def get_sessions
    sessions = [{text: 'No session', value: 'No session'}] + ConferenceResource.where(parent_id: params[:id]).select(:title, :id).distinct().order(:title).map { |obj| {text: obj.title, value: obj.id} }
    render json: sessions.to_json
  end

  private

  # Method used to find Default ConferenceResource
  def find_resource
    @resource = ConferenceResource.find(params[:id])
  end

  # Method used to find Default ConferenceEvent
  def find_event
    @event = ConferenceEvent.find(params[:id])
  end
end
