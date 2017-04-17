require "scrapper/pdf_scrapper"
module PapersHelper
  def extractTextFromPdf(paper, conference_id)
    pdf_path = paper.pdf.path
    scrapper = PDFScrapper.new("dummy", PDFScrapper::PageType[:personal])
    txt_file = Rails.root.join('public', 'conference', conference_id, 'txt', File.basename(paper.pdf_file_name, File.extname(paper.pdf_file_name)) + ".txt")
    txt_folder = Rails.root.join('public', 'conference', conference_id, 'txt')
    FileUtils::mkdir_p txt_folder
    scrapper.convertSinglePdfToText(pdf_path, txt_folder)
    paper.update(path: txt_file)
  end
end