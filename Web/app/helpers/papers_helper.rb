module PapersHelper

  def extractTextFromPdf(paper, conference_id)
    pdf_path = paper.pdf.path
    unless pdf_path.nil?
      scrapper = PDFScrapper.new("dummy", PDFScrapper::PageType[:personal])
      txt_file = Rails.root.join('public', 'conference', conference_id, 'txt', File.basename(paper.pdf_file_name, File.extname(paper.pdf_file_name)) + ".txt")
      txt_folder = Rails.root.join('public', 'conference', conference_id, 'txt')
      FileUtils::mkdir_p txt_folder
      scrapper.convertSinglePdfToText(pdf_path, txt_folder)
      paper.update(path: txt_file)
    end
  end

  def create_paper_authors(author_params, paper)
    unless author_params[:author].blank?
      count = 0
      affiliation_arr = Array.new
      email_arr = Array.new
      unless author_params[:affiliation].blank?
        affiliation_arr = author_params[:affiliation].split(';')
      end
      unless author_params[:email].blank?
        email_arr = author_params[:email].split(';')
      end
      aff_len = affiliation_arr.size
      email_len = email_arr.size
      for author in author_params[:author].split(';')
        affiliation = ""
        email = ""
        if aff_len > count
          affiliation = affiliation_arr[count]
        end
        if email_len > count
          email = email_arr[count]
        end
        count += 1
        if not paper.paper_authors.create!({name: author, affiliation: affiliation, email: email})
          return false
        end
      end
    end
    return true
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

  def create_paper(paper_params, author_params, conference_id, paper_path)
    paper_params[:year] = DateTime.new(paper_params[:year].to_i)
    # "Create a new paper"
    paper = Paper.new(paper_params)
    if paper.save
      unless paper_path.nil?
        paper.save_pdf_path(paper_path)
      end

      # "Create author entry for each author"
      if not create_paper_authors(author_params, paper)
        return nil
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