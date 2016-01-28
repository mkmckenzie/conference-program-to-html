require 'csv'

class ConfProgram
  def initialize(file_to_format, file_to_export)
    @file_to_format = file_to_format
    @saturday = []
    @sunday = []
    @monday = []
    @tuesday = []
    @wednesday = []
    @thursday = []
    @file_to_export = file_to_export
  end

  def sort_by_day
    CSV.foreach(@file_to_format) do |row|
      @saturday << row if row[0].include?"April 2"
      @sunday << row if row[0].include?"April 3"
      @monday << row if row[0].include?"April 4"
      @tuesday << row if row[0].include?"April 5"
      @wednesday << row if row[0].include?"April 6"
      @thursday << row if row[0].include?"April 7"
    end

  end

  def build_program
    self.sort_by_day
    conf_dates = [["Saturday, April 2, 2016", @saturday], ["Sunday, April 3, 2016", @sunday],["Monday, April 4, 2016", @monday], ["Tuesday, April 5, 2016", @tuesday], ["Wednesday, April 6, 2016", @wednesday], ["Thursday, April 7, 2016", @thursday]]
    @schedule = ""
    conf_dates.each do |day_of_week|
      if day_of_week[1].empty?
        @schedule << "\n"
      else
      @schedule << "<h2 class=\"titleDate\">#{day_of_week[0]}</h2>\n
      <table id=\"#{day_of_week.first[/^(\w+\b)/].downcase}\">"
      @schedule << self.format_daily_schedule(day_of_week[1]).to_s
      @schedule << "</table> \n
      <hr />"
      end
    end
  end

  def format_daily_schedule(day_of_week)
    @daily_schedule = ""
    day_of_week.each do |row|
      session_date = row[0]
      start_time = row[1]
      end_time = row[2]
      session_title = row[3]
      speakers = row[4]
      summary = row[5]
      conf_code = row[6]
      link = row[7]
      location = row[8]
      speakers.gsub!(/,/, '<br />') if speakers.include?","
        @daily_schedule << "<tr> \n
          <td class=\"#{conf_code} dateTime\"> \n
         #{start_time} &ndash; #{end_time}\n
          </td> \n
          <td class=\"#{conf_code} sessionInfo\"> \n
          <strong>#{session_title}</strong><br />\n
          <em>#{speakers}</em>\n
          <br />#{location}<br /><br />#{summary}<br />"
        if row[7] == "#"
         @daily_schedule << "\n"
        else
          @daily_schedule  << "<br /><a href=\"#{link}\">Click here for more information</a>\n"        
        end
        @daily_schedule << "</td>\n
        </tr>"
    end
    return @daily_schedule
  end

  def export_program_to_file
    self.build_program
    output = File.open(@file_to_export, "w")
    output.puts @schedule
    output.close
  end
    

end

swanapalooza = ConfProgram.new('program.csv', 'program.html')
swanapalooza.export_program_to_file

