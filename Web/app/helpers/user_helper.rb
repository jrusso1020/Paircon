module UserHelper

  def scrapeUserProfile(user)
    #Ensuring the folder exists
    pdf_folder = user.get_pdf_folder_path
    FileUtils::rm_rf pdf_folder
    FileUtils::mkdir_p pdf_folder
    txt_folder = user.get_pdf_text_path
    FileUtils::rm_rf txt_folder
    FileUtils::mkdir_p txt_folder

    #Running pdf to txt conversion
    url = user.url
    scrapper = PDFScrapper.new(url, 'personal')
    scrapper.downloadAllPdfs(pdf_folder)
    scrapper.convertPdfToText(pdf_folder, txt_folder)

    #setting the status to true
    user.is_scraped = true
    user.save
  end

end
