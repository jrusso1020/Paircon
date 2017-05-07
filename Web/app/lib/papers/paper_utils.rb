require 'scrapper/pdf_scrapper'

class PaperUtils
  def self.extractTextFromPdf(paper, conference_id)
    pdf_path = paper.pdf.path
    conference = Conference.find(conference_id)
    unless pdf_path.nil?
      scrapper = PDFScrapper.new('dummy', PDFScrapper::PageType[:personal])
      txt_folder = conference.get_pdf_text_path
      txt_file = Rails.root.join(txt_folder, File.basename(paper.pdf_file_name, File.extname(paper.pdf_file_name)) + '.txt')
      FileUtils::mkdir_p txt_folder
      scrapper.convertSinglePdfToText(pdf_path, txt_folder)
      paper.update(path: txt_file)
    end
  end

  def self.create_conference_papers(conference_id, paper)
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