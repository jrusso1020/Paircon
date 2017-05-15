# Job for performing and generating user and conference paper recommendations
class ConferencePaperRecommendationJob < ApplicationJob
  queue_as :default

  # Perform recommendations for a user and a particular conference
  # @param user_id [String] the identifier of a user
  # @param conference_id [String] the identifier of a conference
  def perform(user_id, conference_id)
    RecommendationService.new(user_id, conference_id).getRecommendationsForEachPaper()
  end
end
