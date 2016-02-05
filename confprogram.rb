require 'csv'

class ConfProgram
  def initialize(file_to_format, date_file, file_to_export)
    @file_to_format = file_to_format
    @file_to_export = file_to_export
    @date_file = date_file
    @saturday = []
    @sunday = []
    @monday = []
    @tuesday = []
    @wednesday = []
    @thursday = []
    puts "Starting program build....."
  end
=begin
  def get_variables
    @conf_dates = []
    CSV.foreach(@date_file) do |row|
      day = []
      day << "#{row[0]}, #{row[1]} #{row[2]}, #{row[3]}"
      day_name = row[0].downcase
      day << day_name.instance_variable_set("@#{day_name}", day_name)
      @conf_dates << day
    end
    #get rid of headers
    @conf_dates.delete_at(0)

    #@conf_dates.each do |row|
    #  row[1] = []
    #end

    puts @conf_dates
    #puts conf_dates[0][1].instance_variable_defined?("@weekday")
    #puts conf_dates[0][1].class


  end

=end
  def sort_by_day
    i = 0
    CSV.foreach(@file_to_format) do |row|
      @saturday << row if row[0].include?"April 2"
      @sunday << row if row[0].include?"April 3"
      @monday << row if row[0].include?"April 4"
      @tuesday << row if row[0].include?"April 5"
      @wednesday << row if row[0].include?"April 6"
      @thursday << row if row[0].include?"April 7"
      i += 1
    end
    puts "#{i} rows sorted by day"
  end

  def build_program
    #self.get_variables
    self.sort_by_day
    @schedule = ""
    week_dates = [["Saturday, April 2, 2016", @saturday], ["Sunday, April 3, 2016", @sunday], ["Monday, April 4, 2016", @monday], ["Tuesday, April 5, 2016", @tuesday], ["Wednesday, April 6, 2016", @wednesday], ["Thursday, April 7, 2016", @thursday]]
    week_dates.each do |day_of_week|
      #puts day_of_week[1]
      if day_of_week[1].empty?
        @schedule << "\n"
      else
      @schedule << "<h2 class=\"titleDate\">#{day_of_week[0]}</h2>\n<br />
      <table class=\"schedule\" id=\"#{day_of_week.first[/^(\w+\b)/].downcase}\">"
      @schedule << self.format_daily_schedule(day_of_week[1]).to_s
      @schedule << "</table> \n
      <hr />"
      puts "#{@number_of_sessions} added to #{day_of_week[0]}"
      end
    end
    puts "Program built"

  end

  def format_daily_schedule(day_of_week)
    @daily_schedule = ""
    @number_of_sessions = 0
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
      speakers.to_s.gsub!(/;/, '<br />') if speakers.include?";"
        @daily_schedule << "<tr> \n
          <td class=\"#{conf_code} dateTime\"> \n
         #{start_time} &ndash; #{end_time}\n
          </td> \n
          <td class=\"#{conf_code} sessionInfo\"> \n
          <strong>#{session_title}</strong>\n"
          @daily_schedule << "<br class=\"beforelocation\"/><em>#{speakers}</em>\n"  if speakers != "."
          @daily_schedule << "<br class=\"beforespeakers\"/>#{location}<br class=\"afterlocation\"/>" if location != "."        
          @daily_schedule << "<br class=\"beforesummary\"/>#{summary}<br class=\"aftersummary\"/>" unless summary == "."
          @daily_schedule << "<br /><a href=\"#{link}\">Click here for more information</a>\n" if link != "#"
        @daily_schedule << "<div class=\"circle\"></div></td>\n</tr>"
        @number_of_sessions += 1
    end
    #Doesn't work without explicitly stating return value!!!!
  return @daily_schedule
  end

  def export_program_to_file
    self.build_program
    output = File.open(@file_to_export, "w")
    output.puts @schedule
    output.close
    puts "HTML Exported to File"
  end

end

swanapalooza = ConfProgram.new('swanapalooza.utf8.csv', 'conf-dates.csv', 'SPprogram.html')
swanapalooza.export_program_to_file

#testrun = ConfProgram.new('program.csv', 'conf_dates.csv', 'program.html')
#testrun.export_program_to_file

#iconv -c -t utf8 filename.csv > filename.utf8.csv

