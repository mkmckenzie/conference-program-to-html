require 'csv'

class ConfProgram
	def initialize(file_to_format)
		@file_to_format = file_to_format
		@saturday = []
		@sunday = []
		@monday = []
		@tuesday = []
		@wednesday = []
		@thursday = []
	end

	def break_it_up
		CSV.foreach(@file_to_format) do |row|
			@saturday << row if row[0].include?"April 2"
			@sunday << row if row[0].include?"April 3"
			@monday << row if row[0].include?"April 4"
			@tuesday << row if row[0].include?"April 5"
			@wednesday << row if row[0].include?"April 6"
			@thursday << row if row[0].include?"April 7"
		end

	end

	def format_dates
		self.break_it_up
		conf_dates = [["Saturday, April 2, 2016", @saturday], ["Sunday, April 3, 2016", @sunday],["Monday, April 4, 2016", @monday], ["Tuesday, April 5, 2016", @tuesday], ["Wednesday, April 6, 2016", @wednesday], ["Thursday, April 7, 2016", @thursday]]
		conf_dates.each do |day_of_week|
			if day_of_week[1].empty?
				puts "\n"
			else
			puts "<h2 class=\"titleDate\">#{day_of_week[0]}</h2>"
			puts "<table id=\"#{day_of_week.first[/^(\w+\b)/].downcase}\">"
			self.format_this_shit(day_of_week[1])
			puts "</table>"
			puts "<hr />"
			end
		end
		
	end

	def format_this_shit(day_of_week)
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
			puts "<tr>"
				puts "<td class=\"#{conf_code} dateTime\">"
				puts "#{start_time} &ndash; #{end_time}"
				puts "</td>"
				puts "<td class=\"#{conf_code} sessionInfo\">"
				puts "<strong>#{session_title}</strong><br />"
				speakers.gsub!(/,/, '<br />') if speakers.include?","
				puts "<em>#{speakers}</em>"
				puts "<br />#{location}<br /><br />#{summary}<br />"
				if row[7] == "#"
					puts "\n"
				else
					puts "<br /><a href=\"#{link}\">Click here for more information</a>"				
				end
				puts "</td>"
			puts "</tr>"
		end
	end

		

end

swanapalooza = ConfProgram.new('program.csv')
swanapalooza.format_dates

