# Job for scraping text from paper pdf
class PaperScrapperJob < ApplicationJob
  require 'papers/paper_utils'
  queue_as :default

  # This function is called whenever this job is enqueued as a background job.
  # Calls the extractTextFromPdf function of PaperUtils.
  # Extracts text from the pdf file.
  # @param paper [Paper] paper object whose attachment is to be scraped and stored as text file
  # @param conference_id [String] id of the conference, paper is associated with
  def perform(paper, conference_id)
   PaperUtils.extractTextFromPdf(paper, conference_id)
  end

end
