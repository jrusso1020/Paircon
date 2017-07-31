# Utility file for Paper related functionality
class PaperUtils
  require 'scrapper/pdf_scrapper'

  # Extracts text from the pdf associated with the paper (Mostly for conference papers).
  # Stores the text file path in the database
  # @param paper [Paper] paper object whose attachment is to be scraped and stored as text file
  # @param conference_id [String] id of the conference, paper is associated with
  # @return None
  def self.extractTextFromPdf(paper, conference_id)
    pdf_path = paper.pdf.path
    conference = Conference.find(conference_id)
    unless pdf_path.nil?
      scrapper = PDFScrapper.new('dummy', PDFScrapper::PAGETYPE[:personal])
      txt_folder = conference.get_pdf_text_path
      txt_file = Rails.root.join(txt_folder, File.basename(paper.pdf_file_name, File.extname(paper.pdf_file_name)) + '.txt')
      FileUtils::mkdir_p txt_folder
      scrapper.convertSinglePdfToText(pdf_path, txt_folder)
      paper.update(path: txt_file)
    end
  end

  # Runs the pdf to text conversion job for a paper.
  # The background job in turn calls the extractTextFromPdf function in paper_utils.
  # @param conference_id [String] id of the conference, paper is associated with
  # @param paper [Paper] paper object whose attachment is to be scraped and stored as text file
  # @return [Boolean] return true if either the scraping job is added to the queue or paper was extracted on the spot
  def self.create_conference_papers(conference_id, paper)
    if Conference.find(conference_id).conference_papers.create!(paper_id: paper.id)
      begin
        PaperScrapperJob.perform_later(paper, conference_id)
      rescue => e
        Rails.logger.error(e.inspect)
        extractTextFromPdf(paper, conference_id)
      end
      return true
    else
      return false
    end
  end

  # Create a paper object in the database
  # @param paper_params [Map] map containing paper parameters that are stored in the database
  # @param conference_id [String] id of the conference, paper is associated with
  # @param paper_path [String] path to the pdf of the paper
  # @return [Paper] returns the paper object created or return nil in case of failure
  def self.create_paper(paper_params, conference_id, paper_path)
    paper_params[:year] = DateTime.new(paper_params[:year].to_i)
    # "Create a new paper"
    paper = Paper.new(paper_params)
    if paper.save
      unless paper_path.nil?
        paper.save_pdf_path(paper_path)
      end

      # "Create conference paper entry to link paper to conference"
      # "This also create the pdf scrapping job"
      if not create_conference_papers(conference_id, paper)
        return nil
      end

    else
      return nil
    end

    return paper
  end
end