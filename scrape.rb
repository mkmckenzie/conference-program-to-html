require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

class GrabConfInfo
  attr_accessor :first_name, :last_name, :speaker_title, :speaker_company, :bio, :photo, :website, :twitter, :facebook, :linkedin, :attendee_id, :speaker_id

	def initialize(file_with_session_pages, export_session_file, export_speaker_file)
    @file_with_session_pages = file_with_session_pages
    @export_session_file = export_session_file
    @export_speaker_file = export_speaker_file
    puts "Clearing files..."
    File.truncate(@export_speaker_file, 0)
    write_to_csv(
      [
        "First Name (required)", "Last Name (required)", "Title", "Company", 
        "Description", "Image URL", "Website", "Twitter Handle", "Facebook URL",  
        "LinkedIn URL", "Session IDs", "Attendee ID", "Speaker ID"
        ], 
      @export_speaker_file)
    File.truncate(@export_session_file, 0)
    write_to_csv(
      [
        "Name (required)", "Description", "Start Time (required)", 
        "End Time (required)", "Location",  "Session Tracks",  "Filters", 
        "Speaker IDs", "Link URLs", "Session ID"
      ], @export_session_file)
    puts "Starting extraction..."
  end

  def get_info_from_page
    CSV.foreach(@file_with_session_pages, :headers => true) do |row|
      session_date = row[0].gsub("`April ", "04/0") + "/16"
      start_time = format_time(row[1], session_date)
      end_time = format_time(row[2], session_date)
      session_title = row[3]
      speakers = row[4]
      summary = row[5]
      conf_code = row[6]
      link = row[7]
      location = row[8]
      filters = " "
      description = " "
      session_id = format_session_id(session_title, session_date, conf_code, start_time)
      @speaker_ids = ""

      unless link == "#" or speakers == "."
        page = Nokogiri::HTML(open(link))
        description = page.css("table").css("tr:nth-child(1)").css("td:nth-child(1)").inner_html
        speakers_ary = speakers.split(';')
        speakers_ary.each {|speaker| 
                            get_info_for_each_speaker(speaker.split(','),
                            session_id, link)}
      else
        description = summary
        link = ""
      end

      description = format_text(description)

      total_session = [
        session_title, description, start_time, end_time, location, conf_code, 
        filters, @speaker_ids, link, session_id
      ]
      write_to_csv(total_session, @export_session_file)
    end
  end

  def get_info_for_each_speaker(array_of_speaker_info, session_id, link_to_page)
    first_name, last_name = format_speaker_name(array_of_speaker_info)
    speaker_title = 
      if array_of_speaker_info[1] === "P.E." or "Ph.D." or "S.C." 
        if array_of_speaker_info[-1].include?("Inc.") or array_of_speaker_info[-1].include?("LLC") 
          array_of_speaker_info[-3]
        else
        array_of_speaker_info[-2]
      end
      else
        array_of_speaker_info[1]
      end
    speaker_company = format_speaker_company(array_of_speaker_info)
    speaker_id = first_name[0] + last_name
    speaker_id.gsub!(/\W/,"")
    @speaker_ids << speaker_id + ","

    page = Nokogiri::HTML(open(link_to_page))
    page.encoding = 'UTF-8'
    bio = "COMING SOON"

    #photo_column = page.css('table').css('tr').css('td:nth-child(1)').to_a
    #photo_column.each do |cell|
    #  photo = 
    #    if cell.include?("#{last_name}.png")
    #      cell.css('img').attribute('src').value
    #    else
    #      "Not Found"
    #    end
    #end

    bio_column = page.css('table').css('tr').css('td:nth-child(2)').to_a
    bio_column.each do |cell|
      bio = cell.inner_html if cell.inner_html.include?(last_name)
    end

    bio = format_text(bio)

    photo = "http://www.swana.org/Portals/0/events/speakers/#{first_name}#{last_name}.png"

    print "#{first_name} #{last_name}, #{photo}: #{link_to_page} \n" if photo == "Not Found"

    total_speaker = [
      first_name, last_name, speaker_title.lstrip, speaker_company.lstrip, bio, photo, 
      website, twitter, facebook, linkedin, session_id, attendee_id, speaker_id
    ]
    write_to_csv(total_speaker, @export_speaker_file)
  end

  def format_speaker_company(array_of_speaker_info)
    if array_of_speaker_info[-1].include?("Inc.") or array_of_speaker_info[-1].include?("LLC") 
      "#{array_of_speaker_info[-2]},#{array_of_speaker_info[-1]}"
    else
       array_of_speaker_info[-1]
    end
  end

  def format_time(time, date)
    new_time = time.gsub("a.m.", "AM")
    new_time.gsub!("p.m.", "PM")
    formatted = date + " " + new_time
  end

  def format_session_id(session_title, session_date, conf_code, start_time)
    session_id = ""
    session_title.split(" ").each {|string| session_id << string[0]}
    session_id += session_date + conf_code + start_time
    session_id.gsub!(/\W/, "")
  end

  def format_speaker_name(speaker_info)
    info = speaker_info[0].split(" ")
    first_name = 
      if info[0].include?(".")
        info[1]
      else
        info[0]
      end
    last_name = 
      if info.length == 2
        info[1]
      elsif info[1].include?(".")
        info[2]
      else
        info[-1]
      end
    [first_name, last_name]
  end

  def format_text(text_to_be_formatted)
    junk_items = ["<p style=\"text-align: left;\">", "</p>","\n","Â","<div>", "</div>", "<p>"  ]
    junk_items.each { |item| text_to_be_formatted = text_to_be_formatted.gsub(item, "") }
    text_to_be_formatted = text_to_be_formatted.squeeze(" ")
  end


  def write_to_csv(line, file)
    CSV.open(file, "a+") do |row|
      row << line
    end  
  end

end



pages = GrabConfInfo.new('swanapalooza.utf8.csv', 'session-import2.csv', 'speaker-import.csv' )
pages.get_info_from_page
#dnn_ctr2658_HtmlModule_lblContent > table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1)
