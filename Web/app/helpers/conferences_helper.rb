require "csv"
require "zip"

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
    csv_text = File.read(csv)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      params = {}
      row_hash  = row.to_hash
      params[:paper] = {}
      params[:paper][:title] = row_hash["Title"]
      params[:paper][:year] = row_hash["Publication Year"]
      params[:paper][:abstract] = row_hash["Abstract"]
      params[:paper][:author] = row_hash["Authors"].split(";")
      params[:paper][:affiliation] = row_hash["Affiliation"].split(";")
      params[:paper][:email] = row_hash["Emails"].split(";")
      params[:session] = {}
      params[:session][:title] = row_hash["Session Name"]
      params[:session][:start_date] = row_hash["Start DateTime"]
      params[:session][:end_date] = row_hash["End DateTime"]
      params[:session][:presenter] = row_hash["Presenter"]
      params[:session][:event_type] = row_hash["Session Type"]
      params[:resource] = {}
      params[:resource][:title] = row_hash["Session Room"]
      pdf_name = row_hash["Pdf file name"]
      paper_pdf_path = nil
      if pdf_map.has_key?(pdf_name)
        paper_pdf_path = pdf_map[pdf_name]
      end
      paper = create_paper(params[:paper], conference_id, paper_pdf_path)
      if not paper.nil?
        create_conference_events(params[:session], params[:resource], conference_id, paper.id)
      end
    end
  end

  def create_conference_events(session_params, resource_params, conference_id, paper_id)
      # "Look for the resource with the same name in the conference"
      # "If not found, then create one"
      room_title = resource_params[:title]
      resource = Conference.find(conference_id).conference_resources.find_by_title(room_title)
      if resource.nil?
        resource = ConferenceResource.create!(
            conference_id: conference_id,
            title: resource_params[:title],
            parent_id: nil,
            building: nil,
            eventColor: '#' + Digest::MD5.hexdigest(resource_params[:title])[0..5]
        )
      end

      #create the event
      start_date = DateTime.parse(session_params[:start_date])
      Rails.logger.debug("Parsed date time")
      Rails.logger.debug(start_date.inspect)
      end_date = DateTime.parse(session_params[:end_date])
      Rails.logger.debug(end_date.inspect)
      event = ConferenceEvent.create!(
          conference_id: conference_id,
          conference_resource_id: resource.id,
          title: session_params[:title],
          start_date: start_date,
          end_date: end_date,
          presenter: session_params[:presenter],
          event_type: ConferenceEvent.event_types[session_params[:event_type].downcase],
          paper_id: paper_id,
          color: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
      )
  end
end