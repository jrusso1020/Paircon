module ConferencesHelper
  def my_organizing_conferences_published user
    Conference.published.includes(:conference_organizers).where(conference_organizers: {user_id: user.id}).order(:name)
  end

  def my_attending_conferences_published user
    Conference.published.includes(:conference_attendees).where(conference_attendees: {user_id: user.id}).order(:name)
  end

  def my_organizing_conferences_active user
    Conference.active.includes(:conference_organizers).where(conference_organizers: {user_id: user.id}).order(:name)
  end

  def my_attending_conferences_active user
    Conference.active.includes(:conference_attendees).where(conference_attendees: {user_id: user.id}).order(:name)
  end

  def is_organizer conference_id, user
    Conference.find_by_id(conference_id).conference_organizers.exists?(user_id: user.id) and !user.attendee?
  end
end