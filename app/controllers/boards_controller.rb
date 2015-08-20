class BoardsController < ApplicationController
	load_and_authorize_resource
	# require 'rdoc/rdoc'

	def index
		# GC::Profiler.enable
		# # GC.start()
		# GC::Profiler.clear

		@boards = Line.all
		today = DateTime.now.to_date.strftime("%Y-%m-%d")

		@big_data = {}

		Line.all.each do |lines|
			sum_target = 0
			sum_act = 0
			sum_def_int = 0
			sum_def_ext = 0

			arr_line = []
			arr_target = []
			arr_act = []
			arr_def_int = []
			arr_def_ext = []


			reports = lines.reports.find_by("tanggal = ?",DateTime.now.to_date) # <--------------------- uncomment
			#reports = lines.reports.find_by("tanggal = ?","2015-08-13".to_date)

			if reports.present?
				12.times do |jam|
					@temp = false # <--------------------- uncomment
					@jam = jam + 6 # <--------------------- uncomment
					reports.detailreports.order("created_at ASC").each_with_index do |report,index|

						if report.jam.to_i == @jam # <--------------------- uncomment

							sum_target += report.target.to_i
							sum_act += report.act.to_i
							sum_def_int += report.defect_int.to_i
							sum_def_ext += report.defect_ext.to_i
							# arr_target << report.id.to_s+"-"+sum_target.to_s
							# arr_act << report.id.to_s+"-"+sum_act.to_s
							arr_target << sum_target
							arr_act << sum_act
							arr_def_int << sum_def_int
							arr_def_ext << sum_def_ext

							@temp = true
						end # <--------------------- uncomment

					end
					if @temp == false and Time.now.strftime("%H").to_i >= @jam
						arr_target << 0
						arr_act << 0
						arr_def_int << 0
						arr_def_ext << 0
					end

				end # <--------------------- uncomment
				arr_line << arr_target
				arr_line << arr_act
				arr_line << arr_def_int
				arr_line << arr_def_ext

				@big_data[reports.line.no] = arr_line

			end
			# format big_data :

			# @big_data =
			# {
			# 	nomor_mesin => [
			# 		[target],
			# 		[actual],
			# 		[def_int],
			# 		[def_ext]
			# 	]

			# }


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

