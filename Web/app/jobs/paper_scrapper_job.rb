require 'papers/paper_utils'
class PaperScrapperJob < ApplicationJob
  queue_as :default
  def perform(paper, conference_id)
   PaperUtils.extractTextFromPdf(paper, conference_id)
  end
end
