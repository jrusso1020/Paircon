require "recommendation/recommendation_generator"
class ConferencePaperRecommendationJob < ApplicationJob
  queue_as :default

  def perform(user_id, conference_id)
    RecommendationGenerator.new(user_id, conference_id).getRecommendationsForEachPaper()
  end
end
