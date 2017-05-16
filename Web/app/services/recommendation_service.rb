# Service that handles creation and calculation of paper similarity
class RecommendationService

  # Constructor for a recommendation service take the user id and conference id to compute similarities for
  # @param user_id [String] the identifier of a user
  # @param conference_id [String] the identifier of a conference
  def initialize(user_id, conference_id)
    @user = User.find_by(id: user_id)
    @conference = Conference.find_by(id: conference_id)
  end

  # Function that calls Similarity engine to compute similarity scores for each user paper and all conference papers
  def getRecommendationsForEachPaper
    conference_dir = @conference.get_pdf_text_path
    @user.papers.all.each do |user_paper|
      unless @conference.conference_papers.size == Similarity.where(user_paper_id: user_paper.id, conference_paper_id: @conference.conference_papers.pluck(:paper_id)).size
        uri = URI("#{PairConConfig.recommendation_system_domain}/single")
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = { user_file: user_paper.path, conference_dir: conference_dir }.to_json
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end

        response = JSON.parse res.body
        Similarity.transaction do
          response['papers_scores'].each do |conference_obj|
            conference_paper = Paper.find_by(path: conference_obj['conference_paper'])
            if Similarity.find_by(user_paper_id: user_paper.id, conference_paper_id: conference_paper.id, similarity_score: conference_obj['score']).blank?
              Similarity.create!(user_paper_id: user_paper.id, conference_paper_id: conference_paper.id, similarity_score: conference_obj['score'])
            end
          end
        end
      end
    end
  end
end