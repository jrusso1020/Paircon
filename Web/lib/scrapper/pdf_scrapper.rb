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

class PDFScrapper

  # The initialize function takes the url(link) to the profile of the user as well as the type of page - google scholar or personal web page
  def initialize(link, type)
    # Instance variables
    @link = link
    # This is a hack to use the scholar page without google blocking us, get the cookie and then use it.
    h1 = open("http://google.com")
    @cookie = h1.meta['set-cookie'].split('; ',2)[0]
    source = open(link, "User-Agent" => USER_AGENT, "Cookie" => @cookie)
    @doc = Nokogiri::HTML(source)
    @type = type
  end

  # This the main function to be called to get the list of pdf's
  # TODO : add suppoort for personal web page
  def getPdf
    if @type == PageType::GOOGLE_SCHOLAR
        getPdfGoogleScholarPage
    end
  end

  #THis is the function for google scholar web page
  def getPdfGoogleScholarPage
    news_links = @doc.css("a").select{|link| link['class'] == "gsc_a_at"}
    prefix = 'https://scholar.google.com'
    ary = Array.new
    news_links.each do |link|
      link = prefix + link['href']
      begin
        page = Nokogiri::HTML(open(link, "User-Agent" => USER_AGENT, "Cookie" => @cookie))
        #puts page
        page.css('a').each do |pdflink|
          if pdflink['href'] =~ /\b.+.pdf/
            ary.push(pdflink['href'])
          end
          end
      rescue => ex
          puts "Something went wrong...."
      end
    end
    ary
  end

end


d = PDFScrapper.new('https://scholar.google.com/citations?user=jsxk8vsAAAAJ&hl=en', 'google-scholar')
array = d.getPdf
puts array