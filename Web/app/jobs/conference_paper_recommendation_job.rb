class ConferencePaperRecommendationJob < ApplicationJob
  queue_as :default

  def perform(user, conference)
    conference_dir = conference.get_pdf_text_path
    user.user_papers.all.each do |user_paper|
      uri = URI("#{PairConConfig.recommendation_system_domain}/similiarity/v1/compare/single")
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = {user_file: user_paper.paper.path, conference_dir: conference_dir}.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      response = JSON.parse res
      Similiarity.transaction do
        response[:papers_scores].each do |conference_obj|
          conference_paper = Paper.find_by(path: conference_obj[:conference_paper])
          Similiarity.create!(user_paper_id: user_paper.id, conference_paper_id: conference_paper.id, similiarity_score: conference_obj[:score])
        end
      end
    end
  end
end
