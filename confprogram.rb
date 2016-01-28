require 'csv'

#program = CSV.read('program.csv') 

#CSV.foreach('program.csv') do |row|
#	puts row.inspect
#end

class ConfProgram
	def initialize(file_to_format)
		@file_to_format = file_to_format
	end

	def break_it_up
		@saturday = []
		@sunday = []
		@monday = []
		@tuesday = []
		@wednesday = []
		@thursday = []
		CSV.foreach(@file_to_format) do |row|
			@saturday << row if row[0].include?"August 20"
			@sunday << row if row[0].include?"August 21"
			@monday << row if row[0].include?"August 22"
			@tuesday << row if row[0].include?"August 23"
			@wednesday << row if row[0].include?"August 24"
			@thursday << row if row[0].include?"August 25"
		end



	end

	def format_dates
		self.break_it_up
		conf_dates = [["Saturday, August 20, 2016", @saturday], ["Sunday, August 21, 2016", @sunday],["Monday, August 22, 2016", @monday], ["Tuesday, August 23, 2016", @tuesday], ["Wednesday, August 24, 2016", @wednesday], ["Thursday, August 25, 2016", @thursday]]
		conf_dates.each do |day_of_week|
			puts "<h2 class=\"titleDate\">#{day_of_week.first}</h2>"
			puts "<table class=\"#{day_of_week.first}\">"
			self.format_this_shit(day_of_week[1])
			puts "</table>"
			puts "<hr />"
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
					puts "<a href=\"#{link}\">Click here for more information</a>"				
				end
				puts "</td>"
			puts "</tr>"
		end
	end

		

end

swanapalooza = ConfProgram.new('program.csv')
swanapalooza.format_dates

