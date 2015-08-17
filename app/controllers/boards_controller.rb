class BoardsController < ApplicationController
	load_and_authorize_resource


	def index
		@boards = Line.all
		today = DateTime.now.to_date.strftime("%Y-%m-%d")

		@big_data = {}

		Line.all.each do |lines|
			sum_target = 0
			sum_act = 0
			arr_line = []
			arr_target = []
			arr_act = []	
			
			reports = lines.reports.find_by("tanggal = ?",DateTime.now.to_date)
			# reports = lines.reports.find_by("tanggal = ?","2015-08-12".to_date)

			if reports.present?
				12.times do |jam|
					@temp = false
					@jam = jam + 6
					reports.detailreports.order("created_at ASC").each_with_index do |report,index|
						
						if report.jam.to_i == @jam 
							sum_target += report.target.to_i
							sum_act += report.act.to_i
							# arr_target << report.id.to_s+"-"+sum_target.to_s
							# arr_act << report.id.to_s+"-"+sum_act.to_s
							arr_target << sum_target
							arr_act << sum_act
							@temp = true
						end
						#binding.pry
					end
					if @temp == false and Time.now.strftime("%H").to_i >= @jam
						arr_target << 0
						arr_act << 0
					end
					#binding.pry
				end
				arr_line << arr_target
				arr_line << arr_act

				@big_data[reports.line_id] = arr_line
				#binding.pry
			end



		end

	end

	def show

	end

	def new
		
	end

	def create

	end

	def edit

	end

	def update

	end


	def destroy

	end



private

end

