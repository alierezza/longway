class Masteremail < ActiveRecord::Base


	validates :name, :presence=>true, :uniqueness=>true

	def self.generate_excel(tanggal)


	    book = Spreadsheet::Workbook.new
	    sheet1 = book.create_worksheet
	    sheet1.name = Language.find_by(:message=>"Company Title").foreign_language+' Daily Report'

	    sheet1.row(0).push(Language.find_by(:message=>"Company Title").foreign_language+" - Production result on #{tanggal.to_date.strftime('%d %B %Y')} taken at #{Time.now.strftime('%H:%M')}")
	    baris = 0
	    total_length = 0
	    Line.all.where("visible=?",true).order("no").each_with_index do |board,index|

	    	sheet1.row(baris = baris +2).push "Line : #{board.nama}"

	    	if board.reports.where("tanggal=?",tanggal).count == 0
	    		sheet1.row(baris = baris + 1).push "Empty"
	    		#baris += index + 2
	    	else
	    		total_length = get_all_json_length(board.reports.where("tanggal=?",tanggal), total_length)
	    		board.reports.where("tanggal=?",tanggal).all.each_with_index do |report,index2|

					defect_int = Report.merge_defect(report.detailreports, "Internal")
					defect_ext = Report.merge_defect(report.detailreports, "External")

					if defect_int.present?
						length_int = defect_int.length
					else
						length_int = Defect.where(defect_type: "Internal").length
					end

					if defect_ext.present?
						length_ext = defect_ext.length
					else
						length_ext = Defect.where(defect_type: "External").length
					end

					visible = 2
					if check_visibility(report.detailreports)[0] && check_visibility(report.detailreports)[1]
						visible = 0
					elsif check_visibility(report.detailreports)[0]
						visible = 1
					elsif check_visibility(report.detailreports)[1]
						visible = 1
					end

	    			sheet1.row(baris = baris+1).replace Masteremail.generate_header(defect_int, defect_ext, "header", total_length, 0, report.detailreports)
	    			# sheet1.row(baris = baris+1).replace ["HOUR","OPR","TARGET","TARGET (SUM)", "ACT", "ACT (SUM)", "%", "PPH", "ARTICLE","EFFICIENCY (Accumulation)", "DEFECT","","","","","","","","","","","","","", "RFT", "REMARK", "P/O", "MFG No","CATEGORY","COUNTRY"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			format = Spreadsheet::Format.new :color => :black,
                                 :weight => :bold,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    (18+total_length-visible).times do |x| row.set_format(x,format) end
					#sheet1.row(baris).default_format = format
					sheet1.column(0).width = 25
					sheet1.column(1).width = 10
					sheet1.column(2).width = 10
					sheet1.column(3).width = 20
					sheet1.column(4).width = 10
					sheet1.column(5).width = 20
					sheet1.column(6).width = 10
					sheet1.column(7).width = 10 #pph
					sheet1.column(8).width = 70 #article
					sheet1.column(9).width = 30 #effisiensi (akumulasi)

					init_col = 9
					col = 9
					if defect_int.present?
						defect_int.each_with_index do |(key, val), index|
							sheet1.column(col += 1).width = 10
							if (index+1) == defect_int.length
								sheet1.column(col += 1).width = 15
							end
						end
					else
						if Defect.where(defect_type: "Internal").present?
							Defect.where(defect_type: "Internal").each_with_index do |defect, index|
								sheet1.column(col += 1).width = 10
								if (index+1) == Defect.where(defect_type: "Internal").length
									sheet1.column(col += 1).width = 15
								end
							end
						else
							sheet1.column(col += 1).width = 15
						end
					end

					if defect_ext.present?
						defect_ext.each_with_index do |(key, val), index|
							sheet1.column(col += 1).width = 10
							if (index+1) == defect_ext.length
								sheet1.column(col += 1).width = 15
							end
						end
					else
						if Defect.where(defect_type: "External").present?
							Defect.where(defect_type: "External").each_with_index do |defect, index|
								sheet1.column(col += 1).width = 10
								if (index+1) == Defect.where(defect_type: "External").length
									sheet1.column(col += 1).width = 15
								end
							end
						else
							sheet1.column(col += 1).width = 15
						end
					end
					col = col+(total_length-length_int-length_ext)

					col1 = col +1
					sheet1.column(col1).width = 10
					col2 = col1 +1
					sheet1.column(col2).width = 70 #remark
					col3 = col2 +1
					sheet1.column(col3).width = 20 #PO
					col4 = col3 +1
					sheet1.column(col4).width = 20 #MFG NO
					col5 = col4 +1
					sheet1.column(col5).width = 20
					col6 = col5 +1
					sheet1.column(col6).width = 20

					sheet1.merge_cells(baris, init_col+1, baris, col)
					10.times do |y|
						sheet1.merge_cells(baris, y, baris+1, y)
					end

					sheet1.merge_cells(baris, col1, baris+1, col1) #berge rft kolom
					sheet1.merge_cells(baris, col2, baris+1, col2)
					sheet1.merge_cells(baris, col3, baris+1, col3)
					sheet1.merge_cells(baris, col4, baris+1, col4)
					if check_visibility(report.detailreports)[0] && check_visibility(report.detailreports)[1]
						sheet1.merge_cells(baris, col5, baris+1, col5)
						sheet1.merge_cells(baris, col6, baris+1, col6)
					elsif check_visibility(report.detailreports)[0]
						sheet1.merge_cells(baris, col5, baris+1, col5)
					elsif check_visibility(report.detailreports)[1]
						sheet1.merge_cells(baris, col5, baris+1, col5)
					end

	    			sheet1.row(baris = baris+1).replace Masteremail.generate_header(defect_int, defect_ext, "defect_header", total_length, init_col+1, report.detailreports)

					# sheet1.column(10).width = 10
					# sheet1.column(11).width = 10
					# sheet1.column(12).width = 10
					# sheet1.column(13).width = 10
					# sheet1.column(14).width = 10
					# sheet1.column(15).width = 10
					# sheet1.column(16).width = 15 #int(sum)
					# sheet1.column(17).width = 10
					# sheet1.column(18).width = 10
					# sheet1.column(19).width = 10
					# sheet1.column(20).width = 10
					# sheet1.column(21).width = 10
					# sheet1.column(22).width = 10
					# sheet1.column(23).width = 15 #ext(sum)
					# sheet1.column(24).width = 10
					# sheet1.column(25).width = 70 #remark
					# sheet1.column(26).width = 20 #PO
					# sheet1.column(27).width = 20 #MFG NO
					# sheet1.column(28).width = 20
					# sheet1.column(29).width = 20

					# sheet1.merge_cells(baris, 10, baris, 23)
					# 10.times do |y|
					# 	sheet1.merge_cells(baris, y, baris+1, y)
					# end
					# sheet1.merge_cells(baris, 24, baris+1, 24)
					# sheet1.merge_cells(baris, 25, baris+1, 25)
					# sheet1.merge_cells(baris, 26, baris+1, 26)
					# sheet1.merge_cells(baris, 27, baris+1, 27)
					# sheet1.merge_cells(baris, 28, baris+1, 28)
					# sheet1.merge_cells(baris, 29, baris+1, 29)

	    			# sheet1.row(baris = baris+1).replace ["","","","","","","","","","","11A","11B","11C","11J","11L","13D","INT (SUM)","BS2","BS3","BS7","BS13","BS15","BS17","EXT (SUM)"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			(18+total_length-visible).times do |x|
	    				row.set_format(x,format)
	    			end

	    			sum_target = 0
	    			sum_act = 0

	    			@article_x_duration = Array.new{}
					@total_working_time = Array.new{}

	    			report.detailreports.all.order("created_at ASC").each_with_index do |detailreport,index|
	    				sum_target += detailreport.target.to_i
						sum_act += detailreport.act.to_i

						size = detailreport.remark == nil ? 1 : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' ').size
						height = (size / 60 .to_f ).ceil


						# article
						article_detail = Report.article(detailreport)

						# efisiensi (akumulasi)
						efisiensi_akumulasi = Report.efficiency(detailreport.report,detailreport.jam)

						# percent
						percent = Report.percent(detailreport.report, detailreport.jam)

						# PPH
						pph = Report.pph(detailreport.report,detailreport.jam)

						# RFT
						rft = Report.rft(detailreport.report, detailreport.jam)


						sheet1.row(baris = baris+1).replace Masteremail.generate_value(report.detailreports, detailreport, defect_int, defect_ext, sum_target, sum_act, percent, pph, article_detail, efisiensi_akumulasi, rft, total_length)
						# sheet1.row(baris = baris+1).replace [WorkingDay.working_duration(detailreport),detailreport.opr,detailreport.target,sum_target,detailreport.act,sum_act,percent.to_i, pph, ActionView::Base.full_sanitizer.sanitize(article_detail) , efisiensi_akumulasi.html_safe ,detailreport.defect_int,detailreport.defect_int_11b,detailreport.defect_int_11c,detailreport.defect_int_11j,detailreport.defect_int_11l,detailreport.defect_int_13d,Report.total_defect_int(detailreport.report, detailreport.jam),detailreport.defect_ext,detailreport.defect_ext_bs3,detailreport.defect_ext_bs7,detailreport.defect_ext_bs13,detailreport.defect_ext_bs15,detailreport.defect_ext_bs17,Report.total_defect_ext(detailreport.report, detailreport.jam), rft, detailreport.remark == nil ? nil : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' '), detailreport.po, detailreport.mfg, detailreport.category, detailreport.country]
						sheet1.row(baris).height = height * 16
						row = sheet1.row(baris)

						format_normal = Spreadsheet::Format.new :color => :black,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    	format_red = Spreadsheet::Format.new :color => :red,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true

	    				(18+total_length-visible).times do |x|
	    					if x == 4 and detailreport.act < detailreport.target
	    						row.set_format(x,format_red)
	    					else
	    						row.set_format(x,format_normal)
	    					end
	    				end
	    			end

			#sheet1.row(4).push 'Charles Lowe', 'Author of the ruby-ole Library',"sssss"
				end
			end
		end
		path = "#{Rails.root}/data/#{ ActionView::Base.full_sanitizer.sanitize(Language.find_by(:message=>"Company Title").foreign_language) }_#{tanggal.to_date.strftime('%d-%m-%Y')}.xls"
		book.write path

		return path


	end

	def self.generate_header(defect_int, defect_ext, type, total_length, init_col = 0, detailreports)
		if type == "header"
			if defect_int.present?
				int_length = defect_int.length
			else
				int_length = Defect.where(defect_type: "Internal").length
			end

			if defect_ext.present?
				ext_length = defect_ext.length
			else
				ext_length = Defect.where(defect_type: "External").length
			end

			visible = []
			if check_visibility(detailreports)[0] && check_visibility(detailreports)[1]
				visible = ["CATEGORY","COUNTRY"]
			elsif check_visibility(detailreports)[0]
				visible = ["CATEGORY"]
			elsif check_visibility(detailreports)[1]
				visible = ["COUNTRY"]
			end

			header = ["HOUR","OPR","TARGET","TARGET (SUM)", "ACT", "ACT (SUM)", "%", "PPH", "ARTICLE","EFFICIENCY (Accumulation)", "DEFECT"]
			header += (total_length + 1).times.map{ |a| "" }
			# header += (int_length + ext_length + 1).times.map{ |a| "" }
			header += ["RFT", "REMARK", "P/O", "MFG No"] + visible
		else
			if defect_int.present?
				int_header = defect_int.map{ |key, val| key }
			else
				int_header = Defect.where(defect_type: "Internal").map{ |o| o.name }
			end

			if defect_ext.present?
				ext_header = defect_ext.map{ |key, val| key }
			else
				ext_header = Defect.where(defect_type: "External").map{ |o| o.name }
			end

			int_header = int_header + ["INT (SUM)"] if int_header.present?
			int_header = int_header + [""] if !int_header.present?
			ext_header = ext_header + ["EXT (SUM)"] if ext_header.present?
			ext_header = ext_header + [""] if !ext_header.present?

			header = init_col.times.map{ |o| "" }
			header += int_header + ext_header
		end
	end

	def self.generate_value(detailreports, detailreport, defect_int, defect_ext, sum_target, sum_act, percent, pph, article_detail, efisiensi_akumulasi, rft, total_length)
		if JSON.parse(detailreport.defect_int).present? && defect_int.present?
			int_value = defect_int.map{ |k,v| JSON.parse(detailreport.defect_int)[k] }
		elsif JSON.parse(detailreport.defect_int).present?
			int_value = JSON.parse(detailreport.defect_int).map{ |k,v| v }
		elsif defect_int.present?
			int_value = defect_int.map{ |k,v| 0 }
		else
			int_value = Defect.where(defect_type: "Internal").map{ |o| 0 }
		end
		int_value += [Report.total_defect_int(detailreport.report, detailreport.jam)] if int_value.present?
		int_value += ["-"] if !int_value.present?

		if JSON.parse(detailreport.defect_ext).present? && defect_ext.present?
			ext_value = defect_ext.map{ |k,v| JSON.parse(detailreport.defect_ext)[k] }
		elsif JSON.parse(detailreport.defect_ext).present?
			ext_value = JSON.parse(detailreport.defect_ext).map{ |k,v| v }
		elsif defect_ext.present?
			ext_value = defect_ext.map{ |k,v| 0 }
		else
			ext_value = Defect.where(defect_type: "External").map{ |o| 0 }
		end
		ext_value += [Report.total_defect_ext(detailreport.report, detailreport.jam)] if ext_value.present?
		ext_value += ["-"] if !ext_value.present?

		visible = []
		if check_visibility(detailreports)[0] && check_visibility(detailreports)[1]
			visible = [detailreport.category, detailreport.country]
		elsif check_visibility(detailreports)[0]
			visible = [detailreport.category]
		elsif check_visibility(detailreports)[1]
			visible = [detailreport.country]
		end

		value = [WorkingDay.working_duration(detailreport),detailreport.opr,detailreport.target,sum_target,detailreport.act,sum_act,percent.to_i, pph, ActionView::Base.full_sanitizer.sanitize(article_detail) , efisiensi_akumulasi.html_safe]
		value += int_value + ext_value + (total_length-(int_value.length+ext_value.length-2)).times.map{ |o| "-" }
		value += [rft, detailreport.remark == nil ? nil : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' '), detailreport.po, detailreport.mfg] + visible
	end

	def self.get_all_json_length(reports, total_length)
		json = {}
		if reports.present?
			reports.each do |report|
				json = json.merge(Report.merge_defect(report.detailreports, "Internal").merge(Report.merge_defect(report.detailreports, "External")))
			end

			if total_length == 0 || total_length < json.length
				json.length
			else
				total_length
			end
		else
			0
		end
	end

	def self.check_visibility(detailreports)
		[detailreports.where("category is not null").count > 0, detailreports.where("country is not null").count > 0]
	end
end
