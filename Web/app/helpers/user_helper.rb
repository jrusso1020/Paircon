require "scrapper/pdf_scrapper"
module UserHelper

  #delete all the papers that were saved earlier
  def cleanUserProfile(user)
      user.papers.destroy_all
  end

  def scrapeUserProfile(user)
    #Ensuring the folder exists
    pdf_folder = user.get_pdf_folder_path
    FileUtils::rm_rf pdf_folder
    FileUtils::mkdir_p pdf_folder
    txt_folder = user.get_pdf_text_path
    FileUtils::rm_rf txt_folder
    FileUtils::mkdir_p txt_folder

    # Notify the user the job is initiated
    user.activity(:publication_update_begin)

    #Running pdf to txt conversion
    url = user.url
    scrapper = PDFScrapper.new(url, 'personal')
    scrapper.downloadAllPdfs(pdf_folder)
    scrapper.convertPdfToText(pdf_folder, txt_folder)

    Dir.foreach(txt_folder) do |item|
      next if item == '.' or item == '..'
      txt_file = txt_folder + '/' + item
      filepath = pdf_folder + "/" + File.basename(item, File.extname(item)) + ".pdf"
      params = {}
      params[:pdf] = File.open(filepath, 'r')
      params[:path] = txt_file
      paper = Paper.new(params)
      if paper.save
        File.delete(filepath)
        if not user.user_papers.create!({paper_id: paper.id})
          Rails.logger.error("Can not save the user_paper")
        end
      else
        Rails.logger.error("Can not save the paper")
      end
    end

    FileUtils::rm_rf pdf_folder

    #setting the status to true
    user.is_scraped = true
    user.save

    # Notify the user the job is complete
    user.activity(:publication_update_complete)
  end

end
