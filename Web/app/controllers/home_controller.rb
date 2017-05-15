# Controller primarily responsible for handling Home
class HomeController < ApplicationController

  before_action :authenticate_user!, only: [:home, :search]

  # Action to display dashboard upon signing in
  def index
    authenticate_user!
    @notifications = Notification.find_all_notifications(current_user, Notification::NOTIFICATION_LIST_LIMIT)
    @total_notifications = Notification.find_new_notifications(@notifications, current_user)
    @conferences_attendee_list = Conference.my_attending_conferences(current_user).active
    @conferences_organizer_list = Conference.my_organizing_conferences(current_user).active
    @user = current_user

    upcoming_conferences = Conference.my_attending_conferences(current_user).active.where(Conference.arel_table[:start_date].gt(DateTime.now()))
    upcoming_conferences_ids = upcoming_conferences.pluck(:id)
    upcoming_conferences_paper_ids = upcoming_conferences.includes(:papers).select(papers: :id).pluck('papers.id')
    user_paper_ids = current_user.papers.pluck(:id)

    next_conference = upcoming_conferences.limit(1).order(start_date: :asc)[0]
    recommended_similarity = Similarity.includes(:paper_conference).where(user_paper_id: user_paper_ids, conference_paper_id: upcoming_conferences_paper_ids).order(similarity_score: :desc).limit(5)[Random.new.rand(5)]
    no_paper = (recommended_similarity.blank? or recommended_similarity.paper_conference.blank?)

    popular_conference_hash = ConferenceAttendee.where(conference_id: upcoming_conferences_ids).select(:conference_id).group(:conference_id).order('count_conference_id desc').limit(1).count(:conference_id)
    popular_conference = popular_conference_hash.blank? ? nil : Conference.find(popular_conference_hash.keys.first)

    total_recommendations = Similarity.where(user_paper_id: user_paper_ids)
    total_recommendations_count = total_recommendations.count()
    total_recommendations_good = total_recommendations.where(Similarity.arel_table[:similarity_score].gt(0.50)).count()

    @summary = {next_conference: {
        object: next_conference,
        name: next_conference.blank? ? 'N/A' : next_conference.get_name,
        date: next_conference.blank? ? 'N/A' : next_conference.start_date_str,
        location: (next_conference.blank? or next_conference.location.blank?) ? 'N/A' : next_conference.location,
    }, recommended_similarity: {
        object: recommended_similarity,
        paper_exists: !no_paper,
        paper_name: no_paper ? 'N/A' : recommended_similarity.paper_conference.title,
        paper_author: (no_paper or recommended_similarity.paper_conference.author.first.blank?) ? 'N/A' : recommended_similarity.paper_conference.author.first,
        conference_name: no_paper ? 'N/A' : recommended_similarity.paper_conference.conference_paper.conference.get_name,
    }, popular_conference: {
        object: popular_conference,
        name: popular_conference.blank? ? 'N/A' : popular_conference.get_name,
        date: popular_conference.blank? ? 'N/A' : popular_conference.start_date_str,
        count: popular_conference.blank? ? 'N/A' : (popular_conference_hash.values.first.to_s + ' members are interested'),
    }, total_recommendations: {
        count: total_recommendations_count.to_s,
        good_recommendations: total_recommendations_good.to_s + ' have a score of above 50%'
    }
    }
  end

  # Action used to display privacy policy
  def privacy_policy
    render layout: false
  end

  # Action used to display terms and conditions
  def terms
    render layout: false
  end

  # Action for carrying out search and displaying results
  def search
    query = params[:search_val]
    @objects = []
    @objects |= Conference.published.where('lower(name) like ?', "%#{query.downcase}%")
    @objects |= Conference.published.where('lower(location) like ?', "%#{query.downcase}%")
    @objects |= Conference.published.where('lower(domain) like ?', "%#{query.downcase}%")
  end


end
