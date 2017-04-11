class ConferencesController < ApplicationController
  include ConferencesHelper
  before_action :find_conference, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_is_organizer, only: [:show, :home, :schedule, :posts, :about]

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

  # The show action renders the individual conference after retrieving the the id
  def show
    if !@is_organizer and !@conference.publish
      respond_to do |format|
        format.html { render template: 'errors/unauthorized_access', layout: 'layouts/application', status: 403 }
        format.all  { render nothing: true, status: 403 }
      end
    else
      @post_count, @interested_count, @total_resources, @total_events = @conference.get_counts()
    end
  end

  def delete
    render layout: false
  end

  def attend_conference
    attendee = @conference.conference_attendees.where(user_id: current_user.id)

    if attendee.blank?
      @conference.conference_attendees.create(user_id: current_user.id)
      flash[:notice] = "You have successfully joined '#{@conference.get_name}'."
    else
      attendee.destroy_all
      flash[:notice] = "You have successfully been removed from '#{@conference.get_name}'."
    end

    redirect_back(fallback_location: root_path)
  end

  def invite
    conferences_ids = Conference.joins(:conference_organizers).where(conference_organizers: {user_id: current_user.id}).collect(&:id)
    user_ids = ConferenceAttendee.where(conference_id: conferences_ids).select(:user_id).distinct
    @emails_json = User.where(id: user_ids).map { |obj| {id: obj.id, name: obj.email} }.to_json
    render layout: false
  end

  def create_invites
    emails = params[:emails].split(',')

    emails.each do |email|
      if email != current_user.email
        user = User.find_by_id(email)
        if !user.blank?
          @conference.activity(:invite, user)
        end

        begin
          Notifier.conference_invite(@conference, current_user, email, params[:optionalmessage]).deliver_later
        rescue
          Notifier.conference_invite(@conference, current_user, email, params[:optionalmessage]).deliver
        end
      end
    end

    if params[:sendcopy] == 'true'
      begin
        Notifier.conference_invite(@conference, current_user, current_user.email, params[:optionalmessage]).deliver_later
      rescue
        Notifier.conference_invite(@conference, current_user, current_user.email, params[:optionalmessage]).deliver
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def home
    @post_count, @interested_count, @total_resources, @total_events = @conference.get_counts()
    render template: 'conferences/tab_panes/home'
  end

  def schedule
    @total_resources, @total_events = @conference.get_counts(false, false, true, true)
    render template: 'conferences/tab_panes/schedule'
  end

  def posts
    @post_count = @conference.get_counts(true, false, false, false)
    render template: 'conferences/tab_panes/posts'
  end

  def recommendations
    render template: 'conferences/tab_panes/recommendations'
  end

  def about_panel
    @interested_count = @conference.get_counts(false, true, false, false)
    render template: 'conferences/tab_panes/about_panel'
  end

  def papers
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
    @is_organizer = @conference.is_organizer(current_user)
  end
end