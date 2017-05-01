class ConferencesController < ApplicationController
  include ConferencesHelper
  before_action :find_conference, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:home, :schedule, :posts, :about_panel, :show, :invite, :create_invites, :papers]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_is_organizer, only: [:home, :schedule, :papers, :posts, :about_panel, :show]

  def index
    if params[:view] == 'organizer'
      @conferences = Conference.my_organizing_conferences_published(current_user)
      @title = 'Organizing Conferences'
    else
      @conferences = Conference.my_attending_conferences_published(current_user)
      @title = 'Attending Conferences'
    end
  end

  # New action for creating conference
  def new
    render layout: false
  end

  # Create action saves the conference into database
  def create
    @conference = Conference.new()
    if @conference.save
      @conferenceOrganizer = @conference.conference_organizers.create(user_id: current_user.id)
      if @conferenceOrganizer.save
        flash[:notice] = 'We have created your Conference! Now edit the template before publishing it!'

        @conference.activity(:create, current_user)
        redirect_to conference_path(@conference)
      else
        flash[:alert] = 'Error creating your Conference! Please contact our support team.'
        redirect_back(fallback_location: conference_path(@conference))
      end
    else
      flash[:alert] = 'Error creating your Conference! Please contact our support team.'
      redirect_back(fallback_location: conference_path(@conference))
    end
  end

  # Update action updates the conference with the new information
  def update
    redirect_bool = !conference_params[:redirect].blank?
    conference_params.delete('redirect')
    if @conference.update_attributes(conference_params)
      if redirect_bool
        if params[:commit] == 'Publish'
          @conference.activity(:publish, current_user)
          flash[:notice] = 'Your Conference has been successfully published and can now be found in PairCon.'
        elsif params[:commit] == 'Hide'
          @conference.activity(:publish, current_user)
          flash[:notice] = 'Your Conference has been hidden from PairCon users and is unavailable to them.'
        elsif params[:commit] == 'Archive'
          @conference.activity(:archive, current_user)
          flash[:notice] = 'Your Conference has been successfully marked as archived.'
        elsif params[:commit] == 'Restore'
          @conference.activity(:archive, current_user)
          flash[:notice] = 'Your Conference has been restored.'
        end

        redirect_back(fallback_location: root_path)
      else
        render json: {status: :success, text: @conference.get_name}
      end
    else
      flash[:alert] = 'Error updating conference!'
      if redirect_bool
        redirect_back(fallback_location: root_path)
      else
        render json: {status: :error, text: @conference.get_name}
      end
    end
  end

  def create_schedule_dictionary(conference)
    output = {}
    all_resources = conference.conference_resources.map { |obj| {id: obj.id, parent_id: obj.parent_id, room: obj.room, title: obj.title} }
    #separate the events and sessions
    events = {}
    sessions = {}
    all_resources.each do |resource|
      if resource[:parent_id].nil?
        events[resource[:id]] = {}
        events[resource[:id]][:room] = resource[:room]
      elsif sessions[resource[:id]] = resource[:parent_id]
      end
    end

    all_papers = conference.papers.map { |obj| {id: obj.id, author: obj.author, affiliation: obj.affiliation, title: obj.title, url: obj.pdf.url} }
    papers = {}
    all_papers.each do |paper|
      papers[paper[:id]] = paper
    end

    all_details = conference.conference_events.order(:start_date).map { |obj| {id: obj.conference_resource_id, title: obj.title, start_date: obj.start_date, end_date: obj.end_date, presenter: obj.presenter, paper_id: obj.paper_id, event_type: obj.event_type} }

    ordered_event = []
    all_details.each do |details|
      detail_id = details[:id]
      #Not a event
      if events[detail_id].nil?
        session = sessions[detail_id]
        if not session.nil?
          # add to the event
          parent_id = session
          if output[parent_id].nil?
            #create a map in the output
            output[parent_id] = {}
            output[parent_id][:sessions] = []
          elsif if output[parent_id][:sessions].nil?
                  output[parent_id][:sessions] = []
                end
          end
          paper = papers[details[:paper_id]]
          if not paper.nil?
            sessions_params = {title: details[:title],
                               start_time: details[:start_date],
                               end_time: details[:end_date],
                               pdf_link: paper[:url],
                               type: details[:event_type],
                               author: paper[:author],
                               affiliation: paper[:affiliation]
            }
            output[parent_id][:sessions].push(sessions_params)

          end
        end
      else
        #add the event params
        event = events[detail_id]
        if output[detail_id].nil?
          ordered_event.push(detail_id)
          output[detail_id] = {}
          output[detail_id][:title] = details[:title]
          output[detail_id][:room] = event[:room]
          output[detail_id][:start_date] = details[:start_date]
          output[detail_id][:end_date] = details[:end_date]
        end
      end
    end
    final_output = []
    ordered_event.each do |event|
      final_output.push(output[event])
    end

    return final_output
  end

  # The show action renders the individual conference after retrieving the the id
  def show
    logged_in = user_signed_in?
    if (!@is_organizer and !@conference.publish and logged_in) or (!logged_in and !@conference.publish)
      respond_to do |format|
        format.html { render template: 'errors/unauthorized_access', layout: logged_in ? 'layouts/application' : 'layouts/error', status: 403 }
        format.all { render nothing: true, status: 403 }
      end
    else
      @post_count, @interested_count, @total_resources, @total_events = @conference.get_counts()
      render layout: 'public' unless logged_in
    end
  end

  def delete
    render layout: false
  end

  def attend_conference
    attendee = @conference.conference_attendees.where(user_id: current_user.id)

    if attendee.blank?
      @conference.conference_attendees.create(user_id: current_user.id)
      begin
        ConferencePaperRecommendationJob.perform_later(current_user.id, @conference.id)
      rescue Redis::CannotConnectError => e
        RecommendationService.new(user_id, conference_id).getRecommendationsForEachPaper()
      end
      flash[:notice] = "You have successfully joined '#{@conference.get_name}'."
    else
      attendee.destroy_all
      flash[:notice] = "You have successfully been removed from '#{@conference.get_name}'."
    end

    redirect_back(fallback_location: root_path)
  end

  def user_recommendations
    conference = Conference.find_by(id: params[:conference_id])
    user = User.find_by(id: params[:user_id])

    similarities = Similarity.where(user_paper_id: user.user_papers.pluck(:paper_id)).order(similarity_score: :desc).limit(100)
    @papers_with_scores = []
    similarities.each do |item|
      @papers_with_scores << {user_paper: Paper.find_by(id: item.user_paper_id), conference_paper: Paper.find_by(id: item.conference_paper_id), similarity_score: item.similarity_score}
    end

    respond_to do |format|
      format.js
    end
  end

  def invite
    if user_signed_in?
      conferences_ids = Conference.joins(:conference_organizers).where(conference_organizers: {user_id: current_user.id}).collect(&:id)
      user_ids = ConferenceAttendee.where(conference_id: conferences_ids).select(:user_id).distinct
      @emails_json = User.where(id: user_ids).map { |obj| {id: obj.id, name: obj.email} }.to_json
    else
      @email_json = {}
    end

    render layout: false
  end

  def create_invites
    emails = params[:emails].split(',')
    if user_signed_in?
      user_email = current_user.email
      full_name = current_user.full_name
    else
      user_email = ''
      full_name = 'Guest'
    end

    emails.each do |email|
      if email != user_email
        user = User.find_by_id(email)
        if !user.blank?
          @conference.activity(:invite, user)
        end

        begin
          Notifier.conference_invite(@conference, full_name, email, params[:optionalmessage]).deliver_later
        rescue
          Notifier.conference_invite(@conference, full_name, email, params[:optionalmessage]).deliver
        end
      end
    end

    if user_signed_in? and params[:sendcopy] == 'true'
      begin
        Notifier.conference_invite(@conference, full_name, user_email, params[:optionalmessage]).deliver_later
      rescue
        Notifier.conference_invite(@conference, full_name, user_email, params[:optionalmessage]).deliver
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def bulk_upload
    render layout: false
  end

  def process_bulk_upload
    bulk_params = params[:bulk]
    message = @conference.bulk_upload(bulk_params[:csv], bulk_params[:zip])
    render json: {status: 'success', message: message}
  end

  def home
    @post_count, @interested_count, @total_resources, @total_events = @conference.get_counts()
    render template: 'conferences/tab_panes/home'
  end

  def schedule
    @total_resources, @total_events = @conference.get_counts(false, false, true, true)
    @schedule_data = create_schedule_dictionary(@conference)
    render template: 'conferences/tab_panes/schedule'
  end

  def posts
    @post_count = @conference.get_counts(true, false, false, false)[0]
    render template: 'conferences/tab_panes/posts'
  end

  def recommendations
    render template: 'conferences/tab_panes/recommendations'
  end

  def about_panel
    @interested_count = @conference.get_counts(false, true, false, false)[0]
    render template: 'conferences/tab_panes/about_panel'
  end

  def papers
    @total_resources, @total_events = @conference.get_counts(false, false, true, true)
    render template: 'conferences/tab_panes/papers'
  end

  def save_logo
    unless params[:name].blank?
      @conference.save_image(params, true)
    end

    render json: {status: 'success', url: @conference.logo_picture, filename: @conference.logo_file_name}
  end

  def save_cover
    unless params[:name].blank?
      @conference.save_image(params, false)
    end

    render json: {status: 'success', url: @conference.cover_photo, filename: @conference.cover_file_name}
  end

  # The destroy action removes the conference permanently from the database
  def destroy
    Conference.transaction do
      name = @conference.get_name

      if @conference.destroy
        flash[:notice] = "Successfully deleted Conference '" + name + "'."
      else
        flash[:error] = "Unable to delete Conference '" + name + "' due to some error. Please try again later ..."
      end
    end

    redirect_to root_path
  end

  def destroy_logo
    @conference.logo = nil unless @conference.logo.nil?
    @conference.save!(validate: false)
    render json: {status: 'success'}
  end

  def destroy_cover
    @conference.cover = nil unless @conference.cover.nil?
    @conference.save!(validate: false)
    render json: {status: 'success'}
  end

  private

  def set_user
    @user = current_user
  end

  def conference_params
    params.require(:conference).permit!
  end

  def find_conference
    @conference = Conference.find(params[:id])
  end

  def set_is_organizer
    if user_signed_in?
      @is_organizer = @conference.is_organizer(current_user)
    else
      @is_organizer = false
    end
  end
end