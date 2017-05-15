=begin
Author : MAHAK GARG (mg2288)
Class to extract all the pdf links from the google scholar page or a personal web page
=end

# The PDFScrapper class scrapes the PDF off the internet
# Two types of pages are supported - Google scholar and a personal web page with link to pdfs
# The Google Scrapper gets blocked because of restrictions by google - so we may not use it at all
class PDFScrapper
  require 'nokogiri'
  require 'open-uri'
  require 'pdf-reader'
  require 'docsplit'

  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0'

  PageType = {
      google_scholar: 'google-scholar',
      personal: 'personal'
  }
  # Initialize the pdf scrapping profile
  # @param link [String] the link to the user profile url
  # @param type [String] the type of link, can be "google-scholar", "personal" or "dummy" (in case of single pdf scrape)
  def initialize(link, type)
    @link = link
    @type = type
  end


  # Returns the link to the pdfs in an array
  # The pdf links are scraped from the profile link provided during object instantiation
  # @param None
  def getPdf
    if @type == PageType[:google_scholar]
        getPdfGoogleScholarPage
    else
        getPdfPersonalPage
    end
  end

  # Returns the url links to all the pdfs on a personal page of the user
  # @param None
  # @return [Array] array of link to pdfs
  def getPdfPersonalPage
    ary = Set.new()
    begin
      page = Nokogiri::HTML(open(@link, 'User-Agent' => USER_AGENT))
      page.css('a').each do |pdflink|
        if pdflink['href'] =~ /\b.+.pdf/
          ary.add(pdflink['href'])
        end
      end
    rescue => ex
      Rails.logger.error(ex.backtrace)
    end
    ary.to_a
  end

  # getAllLinksFromGoogleScholar is a helper function for getPdfGoogleScholarPage
  # @params cookie [Cookie] cookie object for google.com
  # @return [Array] array of links to individual pages, where pdfs are
  def getAllLinksFromGoogleScholar(cookie)
    links = Array.new
    last_len = -1
    start = 0
    while links.length != last_len
      last_len =links.length
      link = @link + 'view_op=list_works&cstart=' + start.to_s + '&pagesize=100'
      page = Nokogiri::HTML(open(link, 'User-Agent' => USER_AGENT, 'Cookie' => cookie))
      news_links = page.css("a").select{|link| link['class'] == 'gsc_a_at'}
      links += news_links
      start += 100
    end
    links
  end

  # getPdfGoogleScholarPage returns the url links to all the pdfs from the google scholar page
  # For getting pdfs from google scholar we need to get the links to papers first
  # Then we go to each link to get link to the pdf
  # @return [Array] array of link to pdfs
  def getPdfGoogleScholarPage
    # This is a hack to use the scholar page without google blocking us, get the cookie and then use it.
    h1 = open('http://google.com')
    cookie = h1.meta['set-cookie'].split('; ',2)[0]

    news_links = getAllLinksFromGoogleScholar(cookie)
    prefix = 'https://scholar.google.com'
    ary = Set.new()
    news_links.each do |link|
      link = prefix + link['href']
      begin
        page = Nokogiri::HTML(open(link, 'User-Agent' => USER_AGENT, 'Cookie' => cookie))
        page.css('a').each do |pdflink|
          if pdflink['href'] =~ /\b.+.pdf/
            ary.add(pdflink['href'])
          end
          end
      rescue => ex
          Rails.logger.error(ex.backtrace)
      end
    end
    ary.to_a
  end

  # downloadAllPdfs gets all the pdf links from the web
  # It then downloads all the pdfs and then stores them in the folder, given as function argument
  # @params folderName [String] name of the folder where pdfs will be downloaded
  def downloadAllPdfs(folderName)
    links = getPdf
    links.each do |link|
      begin
        download = open(link, 'User-Agent' => USER_AGENT)
        filePath = folderName + '/' + link.split('/').last + ".pdf"
        File.open(filePath, 'w') do |f|
          IO.copy_stream(download, f)
        end
      rescue => ex
        Rails.logger.error(ex.backtrace)
        Rails.logger.error('Could not download ' + link)
      end

    end
  end

  # Extract text from all the pdfs given the links to the pdfs
  # Uses pdf-reader, no need to save pdfs, only give the output folder, but the quality is bad
  # @params folderName [String] name of the folder where pdfs will be downloaded
  def getAllPdfsAsText(folderName)
    links = getPdf
    links.each do |link|
      begin
        download = open(link, 'User-Agent' => USER_AGENT)
        reader = PDF::Reader.new(download)
        filePath = folderName + '/' + link.split('/').last + '.txt'
        File.open(filePath, 'a') do |f|
          reader.pages.each do |page|
            f.write(page.text)
          end
        end
      rescue => ex
        Rails.logger.error(ex.backtrace)
        Rails.logger.error('Could not download ' + link)
      end

    end
  end

  # This is using doc split, first you have to save the pdfs then convert to text
  # Function downloadAllPdfs needs to be called first
  # @param pdfFolder [String] path where the pdfs were downloaded by the downloadAllPdfs function
  # @param txtFolder [String] path where txt extracted from pdfs will be stored as txt files
  def convertPdfToText(pdfFolder, txtFolder)
    Dir.foreach(pdfFolder) do |item|
      next if item == '.' or item == '..'
      filepath = pdfFolder + '/' + item
      begin
        Docsplit.extract_text(filepath, :ocr => false, :output => txtFolder, :clean => true)
      rescue => e
        Rails.logger.error(e.backtrace)
        Rails.logger.error('Error while extracting : ' + filepath)
      end

    end
  end

  # Extracts text from a single pdf and saves it in a folder
  # Uses Docsplit
  # @param pdf [String] path where the pdf to be extracted is present
  # @param txtFolder [String] path where txt extracted from pdfs will be stored as txt files
  def convertSinglePdfToText(pdf, txtFolder)
    Docsplit.extract_text(pdf, :ocr => false, :output => txtFolder, :clean => true)
  end

end