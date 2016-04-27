class BoardsController < ApplicationController
	load_and_authorize_resource
	# require 'rdoc/rdoc'

	def index
		# GC::Profiler.enable
		# # GC.start()
		# GC::Profiler.clear

		if params[:line_no] == "table1"
			@data = Line.where("no >= 1 and no <= 8")
		elsif params[:line_no] == "table2"
			@data = Line.where("no >= 8 and no <= 17")
		elsif params[:line_no].to_i != 0
			#binding.pry
			@data = Line.where("no = ?",params[:line_no].to_i)
			
		else
			@data = Line.all
		end

		@boards = @data.where("visible=?",true)
		today = DateTime.now.to_date.strftime("%Y-%m-%d")

		@big_data = {}

		@boards.order("no").each do |line|
			sum_target = 0
			sum_act = 0
			sum_def_int = 0
			sum_def_ext = 0

			arr_line = []
			arr_target = []
			arr_act = []
			arr_def_int = []
			arr_def_ext = []

			arr_empty = []


			report = line.reports.find_by("tanggal = ?",DateTime.now.to_date) # <--------------------- uncomment
			#reports = lines.reports.find_by("tanggal = ?","2015-08-13".to_date)

				if report.present?
					14.times do |jam|
						@temp = false # <--------------------- uncomment
						@jam = jam + 6 # <--------------------- uncomment
						report.detailreports.order("created_at ASC").each_with_index do |report,index|

							if report.jam.to_i == @jam # <--------------------- uncomment

								sum_target = report.target.to_i
								sum_act = report.act.to_i
								sum_def_int = report.defect_int.to_i
								sum_def_ext = report.defect_ext.to_i
								# arr_target << report.id.to_s+"-"+sum_target.to_s
								# arr_act << report.id.to_s+"-"+sum_act.to_s
								arr_target << sum_target
								arr_act << sum_act
								#arr_def_int << sum_def_int
								#arr_def_ext << sum_def_ext

								@temp = true
							end # <--------------------- uncomment

						end
						if @temp == false and Time.now.strftime("%H").to_i >= @jam
							arr_target << 0
							arr_act << 0
							#arr_def_int << 0
							#arr_def_ext << 0
						end

					end # <--------------------- uncomment
					arr_line << arr_target
					arr_line << arr_act
					#arr_line << arr_def_int
					#arr_line << arr_def_ext

					@big_data[report.line.no] = arr_line

				else



					arr_empty << [0]
					arr_empty << [0]
					#arr_empty << [0]
					#arr_empty << [0]
					@big_data[line.no] = arr_empty
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

			#defect int & ext

			if report.present?

				defect_int = Array.new
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int"),:data=>"JAHIT TANGAN BURUK"})
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int_11b"),:data=>"JAHITAN ROBEK"})
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int_11c"),:data=>"JAHITAN LONGGAR"})
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int_11j"),:data=>"TAK TERJAHIT"})
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int_11l"),:data=>"TAK TEPAT POSISI"})
				defect_int.push({:value=>report.detailreports.sum("detailreports.defect_int_13d"),:data=>"LUBANG KATUB DEFECT"})

				top_3_int = defect_int.sort_by{|data| data[:value]}.pop(3).reverse!

				defect_ext = Array.new
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext"),:data=>"POLA TAK PENUH"})
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext_bs3"),:data=>"TRKENA HMBTN BENDA"})
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext_bs7"),:data=>"BAYANGAN GANDA"})
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext_bs13"),:data=>"TIDAK AKURAT/MIRING"})
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext_bs15"),:data=>"KONTAMINASI TINTA"})
				defect_ext.push({:value=>report.detailreports.sum("detailreports.defect_ext_bs17"),:data=>"FARIASI BEDA WARNA"})

				top_3_ext = defect_ext.sort_by{|data| data[:value]}.pop(3).reverse!

				@big_data[line.no].push(top_3_int.map{|i| i[:value]})
				@big_data[line.no].push(top_3_int.map{|i| i[:data]})
				@big_data[line.no].push(top_3_ext.map{|i| i[:value]})
				@big_data[line.no].push(top_3_ext.map{|i| i[:data]})

			else
				@big_data[line.no].push([0,0,0])
				@big_data[line.no].push(["-","-","-"])
				@big_data[line.no].push([0,0,0])
				@big_data[line.no].push(["-","-","-"])
			end


		end
		
						
	end

	def show

	end

	def new

		begin
			respond_to do |format|
	        	format.json { render json: Ad.first, status: :created }
	    	end
		rescue
		end
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

