class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line_id, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	#### BOARD #########

	def self.efficiency_in_the_board(report) #tampilkan efficiency terakhir saja
		@article_x_duration = Array.new{}
		@total_working_time = Array.new{}

		report.detailreports.order("created_at ASC").each_with_index do |detailreport, index|


			if detailreport.detailreportarticles != [] 
				detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data| 
				
					if Article.find_by_name(data[0]) != nil
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
		end

		if report.detailreports.last.detailreportarticles != []
			return "#{ ((@article_x_duration.sum / ( @total_working_time.sum * report.detailreports.last.opr ) ) * 100) .round(2) }%".html_safe 
		else
			return '-'
		end
	end

	def self.percent_in_the_board(report)
		return ((report.detailreports.sum(:act) / report.detailreports.sum(:target) .to_f * 100 ).to_i ).to_s + "%"
	end

	def self.pph_in_the_board(report)
		return report.detailreports.sum(:act) / (report.detailreports.last.opr * report.detailreports.count) .to_f .round(2)
	end

	def self.rft_in_the_board(report)
		return ((report.detailreports.sum(:act) / ( report.detailreports.sum(:act) + Report.total_defect(report) ) .to_f * 100 ).to_i ).to_s + "%"
	end


	############# REPORT ###############

	

	def self.efficiency_in_the_report(detailreport,article_x_duration,total_working_time) #tampilkan efficiency setiap jam
		
		if detailreport.detailreportarticles != [] 
			detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data| 
			
				if Article.find_by_name(data[0]) != nil
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
					article_x_duration.push(  data[2] * article.duration ) 
					total_working_time.push(  minutes ) 
				end
			end 
		end

		if detailreport.detailreportarticles != []
			return "#{ ((article_x_duration.sum / ( total_working_time.sum * detailreport.opr ) ) * 100) .round(2) }%".html_safe 
		else
			return '-'
		end
	end


	def self.percent_in_the_report(detailreport)
		return ((detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum(:act) / detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum(:target) .to_f * 100 ).to_i ).to_s + "%"
	end

	def self.pph_in_the_report(detailreport)
		return detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum(:act) / (detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).last.opr * detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).count) .to_f .round(2)
	end

	def self.rft_in_the_report(detailreport)
		return ((detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum(:act) / ( detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum(:act) + Report.total_defect_on_that_hour(detailreport) ) .to_f * 100 ).to_i ).to_s + "%"
	end


	#########################

	
	def self.hourly_per_user(user_id,hour) #dari tablet setiap jam manggil
		user = User.find(user_id)
		data = user.line.reports.find_by("tanggal = ?",Date.today)

		opr = data.detailreports.last.opr
		remark = data.detailreports.last.remark
		article = data.detailreports.last.article
		po = data.detailreports.last.po
		mfg = data.detailreports.last.mfg
		target = data.detailreports.last.target

		user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create!(:jam=>hour, :opr=>opr, :remark=>remark, :target=>target, :article=>article, :po=>po, :mfg=>mfg)
	end

	def self.hourly #dari cron

		 User.where("status = ? and role = ?",true,"User").each_with_index do |user,index|
		 	begin
		 		if user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.jam.to_i >= Time.now.strftime("%H").to_i
		 			puts "Sudah ada!(user aktif) user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
		 		else

		 			data = user.line.reports.find_by("tanggal = ?",Date.today)
		 			
		 			opr = data.detailreports.last.opr
					remark = data.detailreports.last.remark
					article = data.detailreports.last.article
					po = data.detailreports.last.po
					mfg = data.detailreports.last.mfg
					target = data.detailreports.last.target

					user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create!(:jam=>hour, :opr=>opr, :remark=>remark, :target=>target, :article=>article, :po=>po, :mfg=>mfg)

		# 			opr = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.opr
		# 			remark = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.remark
		# 			article = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.article
		# 			po = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.po
		# 			mfg = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.mfg
					
		# 			act_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("act").to_i
		# 			rft = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.rft
					
		# 			time = Time.now.strftime("%H").to_i
		# 			if time == 12
		# 				if Time.now.friday? and user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where(:jam=>11).count == 1
		# 					pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.count - 0.5) ) .to_f ).round(2)
		# 				else
		# 					pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.count) ) .to_f ).round(2)
		# 				end

		# 				target = 0
		# 				target_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("target").to_i
		# 			else
		# 				if Time.now.friday? and user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where(:jam=>11).count == 1
		# 					pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where("jam != ?",12).count+1 - 0.5) ) .to_f ).round(2)
		# 				elsif 
		# 					pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where("jam != ?",12).count+1) ) .to_f ).round(2)
		# 				end


		# 				if time == 13
		# 					target = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.offset(1).last == nil ? 0 : user.line.reports.find_by("tanggal = ?",Date.today).detailreports.offset(1).last.target
		# 				else
		# 					target = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.target
		# 				end
						
		# 				target_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("target").to_i  + target.to_i
		# 			end
		# 			percent = target_sum == 0 ? 0 : ((act_sum / target_sum .to_f) *100 ).round(0)
		# 			user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create!(:jam=>Time.now.strftime("%H").to_i, :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark, :target=>target, :article=>article, :po=>po, :mfg=>mfg)
		 			puts "Sukses ! user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
		 		end
		 	rescue Exception => e
		 		puts "errornya: #{e.message}, user: #{user.email}"
		 	end
		 end
	end

	private

	def self.total_defect(report)
		return report.detailreports.sum("defect_int+defect_int_11b+defect_int_11c+defect_int_11j+defect_int_11l+defect_int_13d+defect_ext+defect_ext_bs3+defect_ext_bs7+defect_ext_bs13+defect_ext_bs15+defect_ext_bs17").to_i
	end

	def self.total_defect_on_that_hour(detailreport)
		return detailreport.report.detailreports.accumulation_on_that_hour(detailreport.jam).sum("defect_int+defect_int_11b+defect_int_11c+defect_int_11j+defect_int_11l+defect_int_13d+defect_ext+defect_ext_bs3+defect_ext_bs7+defect_ext_bs13+defect_ext_bs15+defect_ext_bs17").to_i
	end

end
