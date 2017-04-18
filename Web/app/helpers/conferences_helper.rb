module ConferencesHelper

  def papers_by_conference conference_id
    Conference.find_by_id(conference_id).papers.order(:created_at)
  end
end