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
				reports.detailreports.each do |report|

					sum_target += report.target.to_i
					sum_act += report.act.to_i
					# arr_target << report.id.to_s+"-"+sum_target.to_s
					# arr_act << report.id.to_s+"-"+sum_act.to_s
					arr_target << sum_target
					arr_act << sum_act

				end
				arr_line << arr_target
				arr_line << arr_act

				@big_data[reports.line_id] = arr_line
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

