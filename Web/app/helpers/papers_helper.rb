require "scrapper/pdf_scrapper"
module PapersHelper

  def extractTextFromPdf(paper, conference_id)
    pdf_path = paper.pdf.path
    unless pdf_path.nil?
      scrapper = PDFScrapper.new('dummy', PDFScrapper::PageType[:personal])
      txt_file = Rails.root.join('public', 'conference', conference_id, 'txt', File.basename(paper.pdf_file_name, File.extname(paper.pdf_file_name)) + ".txt")
      txt_folder = Rails.root.join('public', 'conference', conference_id, 'txt')
      FileUtils::mkdir_p txt_folder
      scrapper.convertSinglePdfToText(pdf_path, txt_folder)
      paper.update(path: txt_file)
    end
  end

  def create_conference_papers(conference_id, paper)
    if Conference.find(conference_id).conference_papers.create!(paper_id: paper.id)
      begin
        PaperScrapperJob.perform_later(paper, conference_id)
      rescue => e
        extractTextFromPdf(paper, conference_id)
      end
      return true
    else
      return false
    end
  end

  def create_paper(paper_params, conference_id, paper_path)
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