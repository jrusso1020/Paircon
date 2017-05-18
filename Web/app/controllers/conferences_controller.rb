# Controller primarily responsible for handling Conferences
class ConferencesController < ApplicationController
  require 'papers/paper_utils'

  before_action :find_conference, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:home, :schedule, :posts, :about_panel, :show, :invite, :create_invites, :papers]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_is_organizer, only: [:home, :schedule, :papers, :posts, :about_panel, :show]
  before_action :set_view, only: [:posts, :recommendations, :papers]

  # Action used to display information about Organized / Following Conferences
  # @return [HTML] Renders Index View
  def index
    if params[:view] == 'organizer'
      @conferences = Conference.my_organizing_conferences(current_user)
      @title = 'Conferences Organized'
    else
      @conferences = Conference.my_attending_conferences(current_user)
      @title = 'Conferences Followed'
    end
  end

  # Action used to show modal for conference creation
  # @return [HTML] Renders New View
  def new
    render layout: false
  end

  # Action for processing and adding conference to the system
  # @return [HTML] Redirects Back to Old Location
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

  # Action to update information about a conference
  # @return [JSON] Renders Success
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

  # Action used to show information relative to a conference
  # @return [HTML] Renders Show View
  def show
    logged_in = user_signed_in?
    if logged_in and !current_user.all_similarities_generated(@conference.id)
      begin
        ConferencePaperRecommendationJob.perform_later(current_user.id, @conference.id)
      rescue Redis::CannotConnectError => e
        Rails.logger.error(e.inspect)
        RecommendationService.new(current_user.id, @conference.id).getRecommendationsForEachPaper()
      end
    end
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

  # Action used to display modal for conference deletion
  # @return [HTML] Renders Delete View
  def delete
    render layout: false
  end

  # Action used to mark user attendance
  # @return [HTML] Redirects Back to Last Location
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

  # Action used to return recommendations based on a user
  # @return [JS] Responds with User Recommendations (JS)
  def user_recommendations
    user = current_user
    @view_to_render = (params[:view_to_render] == 'true')

    similarities = Similarity.includes(:paper_user, :paper_conference).where(user_paper_id: user.user_papers.pluck(:paper_id)).order(similarity_score: :desc).limit(100)
    @papers_with_scores = []
    similarities.each do |similarity|
      @papers_with_scores << {user_paper: similarity.paper_user, conference_paper: similarity.paper_conference, similarity_score: similarity.similarity_score}
    end

    respond_to do |format|
      format.js
    end
  end

  # Action used to show invitation modal
  # @return [HTML] Renders Invite View
  def invite
    if user_signed_in?
      conferences_ids = Conference.includes(:conference_organizers).where(conference_organizers: {user_id: current_user.id}).collect(&:conference_id)
      user_ids = ConferenceAttendee.where(conference_id: conferences_ids).select(:user_id).distinct
      @emails_json = User.where(id: user_ids).map { |obj| {id: obj.user_id, name: obj.email} }.to_json
    else
      @email_json = {}
    end

    render layout: false
  end

  # Action used to process invite creation
  # @return [HTML] redirects back to last location
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
        user = User.find_by_email(email)
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

  # Action used to show modal for bulk uploading
  # @return [HTML] Renders Bulk Upload View
  def bulk_upload
    render layout: false
  end

  # Action used to process bulk uploading
  # @return [JSON] Renders Status as JSON
  def process_bulk_upload
    bulk_params = params[:bulk]

    if Conference::BULK_SPREADSHEET_MIME_TYPE.include?(bulk_params[:spreadsheet].content_type) and Conference::BULK_ARCHIVE_MIME_TYPE.include?(bulk_params[:zip].content_type)
      tran_success, message = @conference.bulk_upload(bulk_params[:spreadsheet], bulk_params[:zip])
      if tran_success
        render json: {status: :ok, message: message}
      else
        render json: {status: :internal_server_error, message: message}
      end
    else
      render json: {status: :internal_server_error, message: 'You have uploaded a file with an invalid extension. Please try again later ...'}
    end
  end

  # Action used to show Home Tab Pane (AJAX)
  # @return [HTML] Renders Home Tab Pane
  def home
    @post_count, @interested_count, @total_resources, @total_events = @conference.get_counts()
    render template: 'conferences/tab_panes/home'
  end

  # Action used to show Schedule Tab Pane (AJAX)
  # @return [HTML] Renders Schedule Tab Pane
  def schedule
    @total_resources, @total_events = @conference.get_counts(false, false, true, true)
    @schedule_data = ConferenceUtils.create_schedule_dictionary(@conference)
    render template: 'conferences/tab_panes/schedule'
  end

  # Action used to show Posts Tab Pane (AJAX)
  # @return [HTML] Renders Posts Tab Pane
  def posts
    @post_count = @conference.get_counts(true, false, false, false)[0]
    render template: 'conferences/tab_panes/posts'
  end

  # Action used to show Recommendations Tab Pane (AJAX)
  # @return [HTML] Renders Recommendations Tab Pane
  def recommendations
    render template: 'conferences/tab_panes/recommendations'
  end

  # Action used to show About Tab Pane (AJAX)
  # @return [HTML] Renders About Tab Pane
  def about_panel
    @interested_count = @conference.get_counts(false, true, false, false)[0]
    render template: 'conferences/tab_panes/about_panel'
  end

  # Action used to show Papers Tab Pane (AJAX)
  # @return [HTML] Renders Papers Tab Pane
  def papers
    @total_resources, @total_events = @conference.get_counts(false, false, true, true)
    render template: 'conferences/tab_panes/papers'
  end

  # Action used to save logo for the oconference
  # @return [JSON] Renders Status as JSON
  def save_logo
    unless params[:name].blank?
      @conference.save_image(params, true)
    end

    render json: {status: :success, url: @conference.logo_picture, filename: @conference.logo_file_name}
  end

  # Action used to save cover photo for the oconference
  # @return [JSON] Renders Status as JSON
  def save_cover
    unless params[:name].blank?
      @conference.save_image(params, false)
    end

    render json: {status: :success, url: @conference.cover_photo, filename: @conference.cover_file_name}
  end

  # Action used to remove the conference permanently from the database
  # @return [HTML] Redirects to Root Path
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

  # Action used to destroy the logo completely
  # @return [JSON] Renders Status as JSON
  def destroy_logo
    @conference.logo = nil unless @conference.logo.nil?
    @conference.save!(validate: false)
    render json: {status: :ok}
  end

  # Action used to destroy cover photo completely
  # @return [JSON] Renders Status as JSON
  def destroy_cover
    @conference.cover = nil unless @conference.cover.nil?
    @conference.save!(validate: false)
    render json: {status: :ok}
  end

  private

  # Method used to set default user
  def set_user
    @user = current_user
  end

  # Method used to permit conference parameters
  def conference_params
    params.require(:conference).permit!
  end

  # Method used to set default conference
  def find_conference
    @conference = Conference.find(params[:id])
  end

  # Method used set if the user is an organizer or not
  def set_is_organizer
    if user_signed_in?
      @is_organizer = @conference.is_organizer(current_user)
    else
      @is_organizer = false
    end
  end

  # Method used to set information about default view type (Side bar selection)
  def set_view
    params[:view] = 'full'
  end
end