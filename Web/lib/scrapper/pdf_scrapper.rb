=begin
Author : MAHAK GARG (mg2288)
Class to extract all the pdf links from the google scholar page or a personal web page
TODO : Need to add functionality for personal web page
=end

require 'nokogiri'
require 'open-uri'

USER_AGENT = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0"

class PageType
  GOOGLE_SCHOLAR = "google-scholar"
  PERSONAL = "personal"
end

# The PDFScrapper class scrapes the PDF off the internet
# Two types of pages are supported - Google scholar and a personal web page with link to pdfs
# The Google Scrapper gets blocked because of restrictions by google - so we may not use it at all

class PDFScrapper

  # The initialize function takes the link to the profile
  # Type defines whether the url is "google scholar" or "personal"
  def initialize(link, type)
    @link = link
    @type = type
  end


  # The getPdf function returns the link to the pdfs in an array
  # The instance variables needs to be set to use this
  def getPdf
    if @type == PageType::GOOGLE_SCHOLAR
        getPdfGoogleScholarPage
    else
        getPdfPersonalPage
    end
  end

  # getPdfPersonalPage returns the url links to all the pdfs on a personal page of the user
  def getPdfPersonalPage
    ary = Set.new()
    begin
      page = Nokogiri::HTML(open(@link, "User-Agent" => USER_AGENT))
      #puts page
      page.css('a').each do |pdflink|
        if pdflink['href'] =~ /\b.+.pdf/
          ary.add(pdflink['href'])
        end
      end
    rescue => ex
      puts "Something went wrong...."
    end
    ary.to_a
  end

  # getAllLinksFromGoogleScholar is a helper function for getPdfGoogleScholarPage
  def getAllLinksFromGoogleScholar(cookie)
    links = Array.new
    last_len = -1
    start = 0
    while links.length != last_len
      last_len =links.length
      link = @link + "view_op=list_works&cstart=" + start.to_s + "&pagesize=100"
      page = Nokogiri::HTML(open(link, "User-Agent" => USER_AGENT, "Cookie" => cookie))
      news_links = page.css("a").select{|link| link['class'] == "gsc_a_at"}
      links += news_links
      start += 100
    end
    links
  end

  # getPdfGoogleScholarPage returns the url links to all the pdfs from the google scholar page
  # For getting pdfs from google scholar we need to get the links to papers first
  # Then we go to each link to get link to the pdf
  def getPdfGoogleScholarPage
    # This is a hack to use the scholar page without google blocking us, get the cookie and then use it.
    h1 = open("http://google.com")
    cookie = h1.meta['set-cookie'].split('; ',2)[0]

    news_links = getAllLinksFromGoogleScholar(cookie)
    prefix = 'https://scholar.google.com'
    ary = Set.new()
    news_links.each do |link|
      link = prefix + link['href']
      begin
        page = Nokogiri::HTML(open(link, "User-Agent" => USER_AGENT, "Cookie" => cookie))
        page.css('a').each do |pdflink|
          if pdflink['href'] =~ /\b.+.pdf/
            ary.add(pdflink['href'])
          end
          end
      rescue => ex
          puts "Something went wrong...."
      end
    end
    ary.to_a
  end

  # downloadAllPdfs gets all the pdf links from the web
  # It then downloads all the pdfs and then stores them in the folder, given as function argument
  def downloadAllPdfs(folderName)
    links = getPdf
    links.each do |link|
      begin
        download = open(link, "User-Agent" => USER_AGENT)
        filePath = folderName + "/" + link.split('/').last
        File.open(filePath, "w") do |f|
          IO.copy_stream(download, f)
        end
      rescue => ex
        puts "Could not download " + link
      end

    end
  end

end


#d = PDFScrapper.new('https://scholar.google.com/citations?user=jsxk8vsAAAAJ&hl=en', 'google-scholar')
d = PDFScrapper.new('http://www.cs.cornell.edu/~kilian/publications/publications.html', 'personal')
d.downloadAllPdfs('/home/mahak/docs')
