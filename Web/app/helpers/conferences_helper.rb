require "csv"
require "zip"
require "roo"

module ConferencesHelper
  include PapersHelper

  def papers_by_conference conference_id
    Conference.find_by_id(conference_id).papers.order(:created_at)
  end

  #Creates a map of pdf name to the path where it is extracted
  def extract_zip(file, destination)
    FileUtils.mkdir_p(destination)
    pdf_map = {}
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
        if File.file?(fpath)
          pdf_map[File.basename(fpath)] = fpath
        end
      end
    end
    pdf_map
  end

  #Parses the csv and save a paper
  def parse_csv csv, zip_path, conference_id
    pdf_map = extract_zip(zip_path, Conference.find(conference_id).get_conference_pdf_path)
    xlsx = Roo::Spreadsheet.open(csv)
    csv_text = File.read(csv)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      params = {}
      row_hash  = row.to_hash
      # Paper ID ,Title ,Publication Year ,Authors ,Affiliation ,Emails ,Abstract ,Event Title ,\
      # Event Date ,Event Start Time ,Event End Time ,Event Room ,Session Name ,Presenter ,Session Type ,Session Start Time ,Session End Time ,Pdf file name
      params[:paper] = {}
      params[:paper][:title] = row_hash["Title"]
      params[:paper][:year] = row_hash["Publication Year"]
      params[:paper][:abstract] = row_hash["Abstract"]
      params[:paper][:author] = row_hash["Authors"].split(";")
      params[:paper][:affiliation] = row_hash["Affiliation"].split(";")
      params[:paper][:email] = row_hash["Emails"].split(";")
      params[:session] = {}
      params[:session][:title] = row_hash["Event Title"]
      params[:session][:session_title] = row_hash["Session Name"]
      Rails.logger.debug(row_hash["Event Date"])
      params[:session][:event_start_date] = (row_hash["Event Date"] + " " + row_hash["Event Start Time"]).gsub! '/', '//'
      params[:session][:event_end_date] = (row_hash["Event Date"] + " " + row_hash["Event End Time"]).gsub! '/', '//'
      params[:session][:session_start_date] = (row_hash["Event Date"] + " " + row_hash["Session Start Time"]).gsub! '/', '//'
      params[:session][:session_end_date] = (row_hash["Event Date"] + " " + row_hash["Session End Time"]).gsub! '/', '//'
      params[:session][:presenter] = row_hash["Presenter"]
      params[:session][:event_type] = row_hash["Session Type"]
      # params[:resource] = {}
      params[:session][:room] = row_hash["Event Room"]
      pdf_name = row_hash["Pdf file name"]
      paper_pdf_path = nil
      if pdf_map.has_key?(pdf_name)
        paper_pdf_path = pdf_map[pdf_name]
      end
      paper = create_paper(params[:paper], conference_id, paper_pdf_path)
      if not paper.nil?
        create_conference_events(params[:session], conference_id, paper.id)
      end
    end
  end

  def create_conference_events(session_params, conference_id, paper_id)
    Rails.logger.debug(session_params[:event_start_date])
    event_start_date = DateTime.parse(session_params[:event_start_date])
    event_end_date = DateTime.parse(session_params[:event_end_date])
    session_start_date = DateTime.parse(session_params[:session_start_date])
    session_end_date = DateTime.parse(session_params[:session_end_date])

    # "Look for the resource with the same name in the conference"
      # "If not found, then create one"
      event_title = session_params[:title]
      event_resource = Conference.find(conference_id).conference_resources.find_by_title(event_title)
      if event_resource.nil?
        #create the resource for the event
        event_resource = ConferenceResource.create!(
            conference_id: conference_id,
            title: session_params[:title],
            parent_id: nil,
            building: session_params[:room],
            eventColor: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
        )
        #create the corresponding event for the event_resource
        event_event = ConferenceEvent.create!(
            conference_id: conference_id,
            conference_resource_id: event_resource.id,
            title: session_params[:title],
            start_date: event_start_date,
            end_date: event_end_date,
            color: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
        )
      end

      #create the resource for the session
      session_resource = ConferenceResource.create!(
          conference_id: conference_id,
          title: session_params[:session_title],
          parent_id: event_resource.id,
          building: session_params[:room],
          eventColor: '#' + Digest::MD5.hexdigest(session_params[:session_title])[0..5]
      )

      #create the event data for the session
      session_event = ConferenceEvent.create!(
          conference_id: conference_id,
          conference_resource_id: session_resource.id,
          title: session_params[:session_title],
          start_date: session_start_date,
          end_date: session_end_date,
          presenter: session_params[:presenter],
          event_type: ConferenceEvent.event_types[session_params[:event_type].downcase],
          paper_id: paper_id,
          color: '#' + Digest::MD5.hexdigest(session_params[:session_title])[0..5]
      )
  end
end