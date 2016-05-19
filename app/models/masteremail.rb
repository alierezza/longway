class Masteremail < ActiveRecord::Base


	validates :name, :presence=>true, :uniqueness=>true

	def self.generate_excel(tanggal)


	    book = Spreadsheet::Workbook.new
	    sheet1 = book.create_worksheet
	    sheet1.name = 'GlobalWay Daily Report'

	    sheet1.row(0).push "MSB - Production result on #{tanggal.to_date.strftime('%d %B %Y')} taken at 8:00 PM"
	    baris = 0
	    Line.all.where("visible=?",true).order("no").each_with_index do |board,index|

	    	sheet1.row(baris = baris +2).push "Line No: #{board.no}"

	    	if board.reports.where("tanggal=?",tanggal).count == 0
	    		sheet1.row(baris = baris + 1).push "Empty"
	    		#baris += index + 2
	    	else
	    		board.reports.where("tanggal=?",tanggal).all.each_with_index do |report,index2|

	    			sheet1.row(baris = baris+1).replace ["HOUR","OPR","TARGET","TARGET (SUM)", "ACT", "ACT (SUM)", "%", "PPH", "ARTICLE","EFFICIENCY (Accumulation)", "DEFECT","","","","","","","","","","","","","", "RFT", "REMARK", "P/O", "MFG No"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			format = Spreadsheet::Format.new :color => :black,
                                 :weight => :bold,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    28.times do |x| row.set_format(x,format) end
					#sheet1.row(baris).default_format = format
					sheet1.column(2).width = 10
					sheet1.column(3).width = 20
					sheet1.column(4).width = 10
					sheet1.column(5).width = 20
					sheet1.column(6).width = 10
					sheet1.column(7).width = 10 #pph
					sheet1.column(8).width = 70 #article
					sheet1.column(9).width = 30 #effisiensi (akumulasi)
					sheet1.column(10).width = 10
					sheet1.column(11).width = 10
					sheet1.column(12).width = 10
					sheet1.column(13).width = 10
					sheet1.column(14).width = 10
					sheet1.column(15).width = 10
					sheet1.column(16).width = 15 #int(sum)
					sheet1.column(17).width = 10
					sheet1.column(18).width = 10
					sheet1.column(19).width = 10
					sheet1.column(20).width = 10
					sheet1.column(21).width = 10
					sheet1.column(22).width = 10
					sheet1.column(23).width = 15 #ext(sum)
					sheet1.column(24).width = 10
					sheet1.column(25).width = 70 #remark
					sheet1.column(26).width = 20
					sheet1.column(27).width = 20
					sheet1.merge_cells(baris, 10, baris, 23)
					10.times do |y|
						sheet1.merge_cells(baris, y, baris+1, y)
					end
					sheet1.merge_cells(baris, 24, baris+1, 24)
					sheet1.merge_cells(baris, 25, baris+1, 25)
					sheet1.merge_cells(baris, 26, baris+1, 26)
					sheet1.merge_cells(baris, 27, baris+1, 27)
					sheet1.merge_cells(baris, 28, baris+1, 28)
					sheet1.merge_cells(baris, 29, baris+1, 29)
	    			
	    			sheet1.row(baris = baris+1).replace ["","","","","","","","","","","11A","11B","11C","11J","11L","13D","INT (SUM)","BS2","BS3","BS7","BS13","BS15","BS17","EXT (SUM)"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			28.times do |x|
	    				row.set_format(x,format)
	    			end
	    			
	    			sum_target = 0
	    			sum_act = 0
	    			sum_defect_int = 0
	    			sum_defect_ext = 0

	    			@article_x_duration = Array.new{}
					@total_working_time = Array.new{}

	    			report.detailreports.all.order("created_at ASC").each_with_index do |detailreport,index|
	    				sum_target += detailreport.target.to_i
						sum_act += detailreport.act.to_i
						sum_defect_int += detailreport.defect_int+detailreport.defect_int_11b+detailreport.defect_int_11c+detailreport.defect_int_11j+detailreport.defect_int_11l+detailreport.defect_int_13d
						sum_defect_ext += detailreport.defect_ext+detailreport.defect_ext_bs3+detailreport.defect_ext_bs7+detailreport.defect_ext_bs13+detailreport.defect_ext_bs15+detailreport.defect_ext_bs17

						size = detailreport.remark == nil ? 1 : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' ').size
						height = (size / 60 .to_f ).ceil


						# article
						article_detail = ""
						if detailreport.detailreportarticles != []
							article_detail = detailreport.detailreportarticles.map{|i| i.article.to_s + "(act:" + i.output.to_s + ")" + " (opt:" + i.operator.to_s + ")" }.join(", ")
						end


						#effisiensi / article
						if detailreport.detailreportarticles != []
							detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at] }.each do |data|
								
								if Article.find_by_name(data[0]) != nil && data[5].strftime("%H").to_i != 12
									article = Article.find_by_name(data[0])
									if data[5].strftime("%H").to_i >= 16
										if data[5].strftime("%M").to_i < 30
											minutes = 30
										else
											minutes = 60
										end
									else
										minutes = 60
									end
									@article_x_duration.push(  data[2] * article.duration )
									@total_working_time.push(  minutes )
								end
							end
						end


						# efisiensi (akumulasi)
						efisiensi_akumulasi = ""
						if detailreport.detailreportarticles != []   && detailreport.jam != 12 
							efisiensi_akumulasi = " (#{ ((@article_x_duration.sum / ( @total_working_time.sum * detailreport.opr ) ) * 100) .round(2) }%)"
						else
							efisiensi_akumulasi = "-"
						end

						sheet1.row(baris = baris+1).replace [detailreport.jam,detailreport.opr,detailreport.target,sum_target,detailreport.act,sum_act,detailreport.percent.to_i,detailreport.pph, article_detail.html_safe , efisiensi_akumulasi.html_safe ,detailreport.defect_int,detailreport.defect_int_11b,detailreport.defect_int_11c,detailreport.defect_int_11j,detailreport.defect_int_11l,detailreport.defect_int_13d,sum_defect_int,detailreport.defect_ext,detailreport.defect_ext_bs3,detailreport.defect_ext_bs7,detailreport.defect_ext_bs13,detailreport.defect_ext_bs15,detailreport.defect_ext_bs17,sum_defect_ext,detailreport.rft.to_i,detailreport.remark == nil ? nil : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' '), detailreport.po, detailreport.mfg]
						sheet1.row(baris).height = height * 16
						row = sheet1.row(baris)

						format_normal = Spreadsheet::Format.new :color => :black,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    	format_red = Spreadsheet::Format.new :color => :red,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    
	    				28.times do |x|
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
		path = "#{Rails.root}/data/Report_#{tanggal.to_date.strftime('%d-%m-%Y')}.xls"
		book.write path

		return path


	end
end
