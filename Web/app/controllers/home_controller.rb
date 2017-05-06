class HomeController < ApplicationController

  before_action :authenticate_user!, only: [:home, :search]

  def index
    authenticate_user!
    @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT)
    @total_notifications = Notification.find_new_notifications(@notifications, current_user)
    @conferences_attendee_list = Conference.my_attending_conferences(current_user).active
    @conferences_organizer_list = Conference.my_organizing_conferences(current_user).active
    @user = current_user

    upcoming_conferences = Conference.my_attending_conferences(current_user).active.where(Conference.arel_table[:start_date].gt(DateTime.now()))
    next_conference = upcoming_conferences.limit(1).order(start_date: :asc)[0]

    upcoming_conferences_paper_ids = upcoming_conferences.includes(:papers).select(papers: :id).pluck('papers.id')
    user_paper_ids = current_user.papers.pluck(:id)

    recommended_similarity = Similarity.where(user_paper_id: user_paper_ids, conference_paper_id: upcoming_conferences_paper_ids).order(similarity_score: :desc).limit(5)[Random.new.rand(5)]

    @summary = {next_conference: {
                object: next_conference,
                name: next_conference.blank? ? 'N/A' : next_conference.get_name,
                date: next_conference.blank? ? 'N/A' : next_conference.start_date_str,
                location: (next_conference.blank? or next_conference.location.blank?) ? 'N/A' : next_conference.location,
             }, recommended_similarity: {
                object: recommended_similarity
                # name: recommended_similarity.blank? 'N/A' : recommended_similarity.,
             }
    }
  end

  def privacy_policy
    render layout: false
  end

  def terms
    render layout: false
  end


  def search
    query = params[:search_val]
    @objects = []
    @objects |= Conference.not_archived.where('name like ?', "%#{query}%")
    @objects |= Conference.not_archived.where('location like ?', "%#{query}%")
    @objects |= Conference.not_archived.where('domain like ?', "%#{query}%")
  end


end
