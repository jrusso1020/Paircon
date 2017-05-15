# Utility file for conference related functionality
class ConferenceUtils
  require 'zip'
  require 'roo'
  require 'papers/paper_utils'
  require 'simple_xlsx_reader'

  # Extracts all the files from the uploaded zip(during bulk upload of papers).
  # Creates a map of pdf name to the path where it is extracted
  # @param file [String] path to the zip file
  # @param destination [String] folder where the files from the zip are extracted
  # @return [Map] Map of pdf file name to the file path
  def self.extract_zip(file, destination)
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

  # Parses the uploaded spreadsheet(during bulk upload of papers).
  # Save the conference paper and schedule in the database.
  # Uses third party gem called SimpleXlsxReader for parsing.
  # @param spreadsheet [String] path to the spreadsheet
  # @param zip_path [String] path to the uploaded zip file with all the conference paper pdfs
  # @param conference_id [String] id of the conference for which the spreadsheet is uploaded
  # @return [Boolean, String] Boolean value tells whether the parse was successful or not, String is the message returned
  def self.parse_spreadsheet spreadsheet, zip_path, conference_id
    pdf_map = extract_zip(zip_path, Conference.find(conference_id).get_pdf_folder_path)
    xlsx = SimpleXlsxReader.open(spreadsheet)
    tran_success = true
    message = 'Successfully Parsed Excel and added Papers and Events in Bulk'
    if (xlsx.sheets.length != 0)
      sheet = xlsx.sheets.first
      Conference.transaction do
        begin
          sheet.data.each do |row| # Will exclude first (inevitably header) row
            unless row.blank?
              params = {}
              if row[1].nil?
                continue
              end
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
              params[:session][:event_start_date] = DateTime.parse(row[8].to_s).change(hour: row[9].hour, min: row[9].min)
              params[:session][:event_end_date] = DateTime.parse(row[8].to_s).change(hour: row[10].hour, min: row[10].min)
              params[:session][:session_start_date] = DateTime.parse(row[8].to_s).change(hour: row[15].hour, min: row[15].min)
              params[:session][:session_end_date] = DateTime.parse(row[8].to_s).change(hour: row[16].hour, min: row[16].min)
              params[:session][:presenter] = row[13].to_s
              params[:session][:event_type] = row[14].to_s
              params[:session][:room] = row[11].to_s
              pdf_name = row[17].to_s
              paper_pdf_path = nil
              if pdf_map.has_key?(pdf_name)
                paper_pdf_path = pdf_map[pdf_name]
              end
              paper = PaperUtils.create_paper(params[:paper], conference_id, paper_pdf_path)
              if not paper.nil?
                tran_success = create_conference_events(params[:session], conference_id, paper.id)
                unless tran_success
                  message = 'Problem Adding Papers'
                  tran_success = false
                  raise ActiveRecord::Rollback
                end
              else
                tran_success = false
                message = 'Problem Adding Papers'
                raise ActiveRecord::Rollback
              end
            end
          end
        rescue => e
          tran_success = false
          message = 'Problem Adding papers in bulk'
          raise ActiveRecord::Rollback
        end
      end
    end

    return tran_success, message
  end

  # Parses the uploaded spreadsheet(during bulk upload of papers).
  # Save the conference paper and schedule in the database.
  # Uses third party gem called ROO for parsing.
  # @deprecated ROO was giving issues with time, so not using this function
  # @param spreadsheet [String] path to the spreadsheet
  # @param zip_path [String] path to the uploaded zip file with all the conference paper pdfs
  # @param conference_id [String] id of the conference for which the spreadsheet is uploaded
  # @return [Boolean, String] Boolean value tells whether the parse was successful or not, String is the message returned
  def self.parse_spreadsheet_roo spreadsheet, zip_path, conference_id
    pdf_map = extract_zip(zip_path, Conference.find(conference_id).get_pdf_folder_path)
    xlsx = Roo::Spreadsheet.open(spreadsheet)
    tran_success = true
    message = 'Successfully Parsed Excel and added Papers and Events in Bulk'
    if (xlsx.sheets.count != 0)
      sheet = xlsx.sheet(0)
      Conference.transaction do
        begin
          sheet.each_row_streaming(offset: 1) do |row| # Will exclude first (inevitably header) row
            unless row.blank?
              params = {}
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
              paper = PaperUtils.create_paper(params[:paper], conference_id, paper_pdf_path)
              if not paper.nil?
                tran_success = create_conference_events(params[:session], conference_id, paper.id)
                unless tran_success
                  message = 'Problem Adding Papers'
                  tran_success = false
                  raise ActiveRecord::Rollback
                end
              else
                tran_success = false
                message = 'Problem Adding Papers'
                raise ActiveRecord::Rollback
              end
            end
          end
        rescue => e
          tran_success = false
          message = 'Problem Adding papers in bulk'
          raise ActiveRecord::Rollback
        end
      end
    end

    return tran_success, message
  end

  # Create the event and session entries in the database for a paper.
  # Used by the parse_spreadsheet.
  # @param session_params [Map] map containing the data related to the event and the session the paper is to be presented in
  # @param conference_id [String] id of the conference for which we are creating the events
  # @param paper_id [String] id of the paper which is to be presented during the session
  # @return [Boolean] the boolean value tells whether the addition of event and session was a success or not
  def self.create_conference_events(session_params, conference_id, paper_id)
    event_start_date = session_params[:event_start_date]
    event_end_date = session_params[:event_end_date]
    session_start_date = session_params[:session_start_date]
    session_end_date = session_params[:session_end_date]

    # "Look for the resource with the same name in the conference"
    # "If not found, then create one"
    event_title = session_params[:title]
    conference = Conference.find(conference_id)
    event_resource = conference.conference_resources.find_by_title(event_title)
    if event_resource.nil?
      #create the resource for the event
      event_resource = conference.conference_resources.create!(
          title: session_params[:title],
          parent_id: nil,
          room: session_params[:room],
          eventColor: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
      )
      if event_resource.nil?
        return false
      end
      #create the corresponding event for the event_resource
      event_event = conference.conference_events.create!(
          conference_resource_id: event_resource.id,
          title: session_params[:title],
          start_date: event_start_date,
          end_date: event_end_date,
          color: '#' + Digest::MD5.hexdigest(session_params[:title])[0..5]
      )
      if event_event.nil?
        return false
      end
    end

    #create the resource for the session
    session_resource = conference.conference_resources.create!(
        title: session_params[:session_title],
        parent_id: event_resource.id,
        room: session_params[:room],
        eventColor: '#' + Digest::MD5.hexdigest(session_params[:session_title])[0..5]
    )
    if session_resource.nil?
      return false
    end

    #create the event data for the session
    session_event = conference.conference_events.create!(
        conference_resource_id: session_resource.id,
        title: session_params[:session_title],
        start_date: session_start_date,
        end_date: session_end_date,
        presenter: session_params[:presenter],
        event_type: ConferenceEvent.event_types[session_params[:event_type].downcase],
        paper_id: paper_id,
        color: '#' + Digest::MD5.hexdigest(session_params[:session_title])[0..5]
    )
    if session_event.nil?
      return false
    end
    return true
  end

  # Creates a dictionary/map for the conference schedule.
  # Used for creating detailed schedule in the UI.
  # @param conference [Conference] conference object for which schedule dictionary is created
  # @return [Map] The output map contains information about the events and sessions in the conference and the papers associated with the sessions
  def self.create_schedule_dictionary(conference)
    output = {}
    all_resources = conference.conference_resources.map { |obj| {id: obj.id, parent_id: obj.parent_id, room: obj.room, title: obj.title} }
    #separate the events and sessions
    events = {}
    sessions = {}
    all_resources.each do |resource|
      if resource[:parent_id].nil?
        events[resource[:id]] = {}
        events[resource[:id]][:room] = resource[:room]
      else
        sessions[resource[:id]] = resource[:parent_id]
      end
    end

    all_papers = conference.papers.map { |obj| {id: obj.id, author: obj.author, affiliation: obj.affiliation, title: obj.title, url: obj.pdf.url, abstract: obj.abstract} }
    papers = {}
    all_papers.each do |paper|
      papers[paper[:id]] = paper
    end

    all_details = conference.conference_events.order(:start_date).map { |obj| {id: obj.conference_resource_id, title: obj.title, start_date: obj.start_date, end_date: obj.end_date, presenter: obj.presenter, paper_id: obj.paper_id, event_type: obj.event_type} }

    ordered_event = []
    all_details.each do |details|
      detail_id = details[:id]
      #Not a event
      if events[detail_id].nil?
        session = sessions[detail_id]
        unless session.nil?
          # add to the event
          parent_id = session
          if output[parent_id].nil?
            #create a map in the output
            output[parent_id] = {}
            output[parent_id][:sessions] = []
          elsif output[parent_id][:sessions].nil?
            output[parent_id][:sessions] = []
          end
          paper = papers[details[:paper_id]]
          unless paper.nil?
            sessions_params = {title: details[:title],
                               start_time: details[:start_date].strftime(TIMEFORMAT),
                               end_time: details[:end_date].strftime(TIMEFORMAT),
                               start_date: details[:start_date].strftime(DATEFORMAT),
                               end_date: details[:end_date].strftime(DATEFORMAT),
                               pdf_link: paper[:url],
                               type: details[:event_type],
                               author: paper[:author],
                               affiliation: paper[:affiliation],
                               session_id: details[:id],
                               abstract: paper[:abstract]
            }
            output[parent_id][:sessions].push(sessions_params)
          end
        end
      else
        #add the event params
        event = events[detail_id]
        if output[detail_id].nil?
          output[detail_id] = {}
        end
        ordered_event.push(detail_id)
        output[detail_id][:title] = details[:title]
        output[detail_id][:room] = event[:room]
        output[detail_id][:start_date] = details[:start_date]
        output[detail_id][:end_date] = details[:end_date]
        output[detail_id][:event_id] = details[:id]
      end
    end
    final_output = []
    ordered_event.each do |event|
      final_output.push(output[event])
    end
    return final_output
  end

end