class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	#default from: CONFIG["email_dari"]
  	#default from: "dynamic-billboard@id.longwaycorp.com"
  	default from: "visualboard.gwi@gmail.com"

  	def report
  		@temp = Array.new
	    Masteremail.all.each_with_index do |email,index|
	    	@temp.push(email.name)
	    end
	    @temp.join(",")

	    book = Spreadsheet::Workbook.new
	    sheet1 = book.create_worksheet
	    sheet1.name = 'GlobalWay Daily Report'

	    sheet1.row(0).push "Production result on #{Date.today.strftime('%d %B %Y')} taken at 6:10 PM"
	    baris = 0
	    Line.all.where("visible=?",true).order("no").each_with_index do |board,index|

	    	sheet1.row(baris = baris +2).push "Line No: #{board.no}"

	    	if board.reports.where("tanggal=?",Date.today).count == 0
	    		sheet1.row(baris = baris + 1).push "Empty"
	    		#baris += index + 2
	    	else
	    		board.reports.where("tanggal=?",Date.today).all.each_with_index do |report,index2|

	    			sheet1.row(baris = baris+1).replace ["JAM","OPR","TARGET","TARGET (SUM)", "ACT", "ACT (SUM)", "%", "PPH", "DEFECT","","","", "RFT", "REMARK", "ARTICLE"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			format = Spreadsheet::Format.new :color => :black,
                                 :weight => :bold,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    15.times do |x| row.set_format(x,format) end
					#sheet1.row(baris).default_format = format
					sheet1.column(2).width = 10
					sheet1.column(3).width = 20
					sheet1.column(4).width = 10
					sheet1.column(5).width = 20
					sheet1.column(6).width = 10
					sheet1.column(7).width = 10
					sheet1.column(8).width = 10
					sheet1.column(9).width = 15
					sheet1.column(10).width = 10
					sheet1.column(11).width = 15
					sheet1.column(12).width = 10
					sheet1.column(13).width = 70
					sheet1.column(14).width = 15
					sheet1.merge_cells(baris, 8, baris, 11)
					8.times do |y|
						sheet1.merge_cells(baris, y, baris+1, y)
					end
					sheet1.merge_cells(baris, 12, baris+1, 12)
					sheet1.merge_cells(baris, 13, baris+1, 13)
					sheet1.merge_cells(baris, 14, baris+1, 14)
	    			
	    			sheet1.row(baris = baris+1).replace ["","","","","","","","","INT","INT (SUM)","EXT","EXT (SUM)"]
	    			sheet1.row(baris).height = 16
	    			row = sheet1.row(baris)
	    			15.times do |x|
	    				row.set_format(x,format)
	    			end
	    			
	    			sum_target = 0
	    			sum_act = 0
	    			sum_defect_int = 0
	    			sum_defect_ext = 0

	    			report.detailreports.all.order("created_at ASC").each_with_index do |detailreport,index|
	    				sum_target += detailreport.target.to_i
						sum_act += detailreport.act.to_i
						sum_defect_int += detailreport.defect_int.to_i
						sum_defect_ext += detailreport.defect_ext.to_i 

						size = detailreport.remark == nil ? 1 : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' ').size
						height = (size / 60 .to_f ).ceil

						sheet1.row(baris = baris+1).replace [detailreport.jam,detailreport.opr,detailreport.target,sum_target,detailreport.act,sum_act,detailreport.percent.to_i,detailreport.pph,detailreport.defect_int,sum_defect_int,detailreport.defect_ext,sum_defect_ext,detailreport.rft.to_i,detailreport.remark == nil ? nil : detailreport.remark.gsub(/\n/, ' ').gsub(/\r/,' '), detailreport.article]
						sheet1.row(baris).height = height * 16
						row = sheet1.row(baris)

						format_normal = Spreadsheet::Format.new :color => :black,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    	format_red = Spreadsheet::Format.new :color => :red,
                                 :size => 11, :align=>:center, :border =>:thin, :vertical_align =>:middle,:text_wrap => true
                    
	    				15.times do |x|
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
		path = "#{Rails.root}/Report_#{Time.now.strftime('%d-%m-%Y')}.xls"
		book.write path


	    attachments["Report_#{Time.now.strftime('%d-%m-%Y')}.xls"] = File.read(path)
	    mail(to: @temp, subject: "[Global Way Indonesia] Daily Production Report (#{Date.today.strftime('%d %B %Y')})")

	    FileUtils.rm_f(path)
  	end

end
