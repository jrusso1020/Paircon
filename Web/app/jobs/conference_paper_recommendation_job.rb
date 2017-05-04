class ConferencePaperRecommendationJob < ApplicationJob
  queue_as :default

  def perform(user_id, conference_id)
    RecommendationService.new(user_id, conference_id).getRecommendationsForEachPaper()
  end
end
