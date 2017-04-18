require 'scrapper/pdf_scrapper'
class PaperScrapperJob < ApplicationJob
  queue_as :default
  include PapersHelper
  def perform(paper, conference_id)
   extractTextFromPdf(paper, conference_id)
  end
end
