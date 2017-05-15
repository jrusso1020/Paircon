class ConferencePaperRecommendationJob < ApplicationJob
  queue_as :default

  # Job to perform recommendations for a user and a particular conference
  def perform(user_id, conference_id)
    RecommendationService.new(user_id, conference_id).getRecommendationsForEachPaper()
  end
end
