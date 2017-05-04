class RecommendationService

  def initialize(user_id, conference_id)
    @user = User.find_by(id: user_id)
    @conference = Conference.find_by(id: conference_id)
  end

  def getRecommendationsForEachPaper
    conference_dir = @conference.get_pdf_text_path
    @user.papers.all.each do |user_paper|
      uri = URI("#{PairConConfig.recommendation_system_domain}/single")
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = { user_file: user_paper.path, conference_dir: conference_dir }.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      response = JSON.parse res
      Similiarity.transaction do
        response[:papers_scores].each do |conference_obj|
          conference_paper = Paper.find_by(path: conference_obj[:conference_paper])
          if Similiarity.find_by(user_paper_id: user_paper.id, conference_paper_id: conference_paper.id, similiarity_score: conference_obj[:score]).blank?
            Similiarity.create!(user_paper_id: user_paper.id, conference_paper_id: conference_paper.id, similiarity_score: conference_obj[:score])
          end
        end
      end
      ConferenceAttendee.find_by(conference_id: @conference.id, user_id: @user.id).update(recommendation_ran: true)
    end
  end
end