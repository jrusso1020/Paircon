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
    if (xlsx.sheets.count != 0)
      sheet = xlsx.sheet(0)
      headers = sheet.row(0)
      # csv_text = File.read(csv)
      # csv = CSV.parse(csv_text, :headers => true)
      # csv.each do |row|
      sheet.each_row_streaming(offset: 1) do |row| # Will exclude first (inevitably header) row
        params = {}
        # row_hash  = row.to_hash
        params[:paper] = {}
        params[:paper][:title] = row[1].to_s
        params[:paper][:year] = row[2].to_s
        params[:paper][:author] = row[3].to_s.split(";")
        params[:paper][:affiliation] = row[4].to_s.split(";")
        params[:paper][:email] = row[5].to_s.split(";")
        params[:paper][:abstract] = row[6].to_s
        params[:session] = {}
        params[:session][:title] = row[7].to_s
        params[:session][:session_title] = row[12].to_s
        d = DateTime.parse(row[8].to_s.gsub! '/', '//')
        time = Time.at(row[9].value).in_time_zone
        time = time.change(day: d.day, month: d.month, year: d.year)
        params[:session][:event_start_date] = time
        time = Time.at(row[10].value).in_time_zone
        time = time.change(day: d.day, month: d.month, year: d.year)
        params[:session][:event_end_date] = time
        time = Time.at(row[15].value).in_time_zone
        time = time.change(day: d.day, month: d.month, year: d.year)
        params[:session][:session_start_date] = time
        time = Time.at(row[16].value).in_time_zone
        time = time.change(day: d.day, month: d.month, year: d.year)
        params[:session][:session_end_date] = time
        params[:session][:presenter] = row[13].to_s
        params[:session][:event_type] = row[14].to_s
        params[:session][:room] = row[11].to_s
        pdf_name = row[17].to_s
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
  end

  def create_conference_events(session_params, conference_id, paper_id)
    event_start_date = session_params[:event_start_date]
    event_end_date = session_params[:event_end_date]
    session_start_date = session_params[:session_start_date]
    session_end_date = session_params[:session_end_date]

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
            room: session_params[:room],
            eventColor: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
        )
        #create the corresponding event for the event_resource
        ConferenceEvent.create!(
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
          room: session_params[:room],
          eventColor: '#' + Digest::MD5.hexdigest(session_params[:session_title])[0..5]
      )

      #create the event data for the session
      ConferenceEvent.create!(
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