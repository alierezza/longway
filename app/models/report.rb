class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line_id, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true


	def self.if_not_breaking_time(report,hour)
		if report == nil
			report = Time.now.strftime("%A")
		else
			report = report.tanggal.strftime("%A")
		end
		WorkingDay.find_by(:name=>report).working_hours.where.not(:working_state=>"Break").each do |master_hour|

			if hour.to_time.between?(master_hour.start.to_time,master_hour.end.to_time-1)
				return [true,master_hour.start,master_hour.end]
				break
			end
		end

		return [false,"23:59","23:59"]
	end



	#### PERHITUNGAN #########

	# def self.total_working_time_in_minutes(report,hour)
	# 	total_working_time = Array.new{}
	# 	report.detailreports.accumulation_on_that_hour(report,hour).order("created_at ASC").each_with_index do |detailreport, index|
	# 		if detailreport.detailreportarticles != []
	# 			detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data|

	# 				if Article.find_by_name(data[0]) != nil && Report.if_not_breaking_time(report,hour)[0] #data[5].strftime("%H").to_i != 12
	# 					# if data[5].strftime("%H").to_i >= 16
	# 					# 	if data[5].strftime("%M").to_i < 30
	# 					# 		minutes = 30
	# 					# 	else
	# 					# 		minutes = 60
	# 					# 	end
	# 					# elsif data[5].strftime("%H").to_i == 11 && Time.now.friday?
	# 					# 	minutes = 30
	# 					# else
	# 					# 	minutes = 60
	# 					# end

	# 					minutes = WorkingDay.find_by(:name=>report.tanggal.strftime("%A")).working_hours.where.not(:working_state=>"Break").where(:start=>hour).map{|i|  (i.end.to_time-i.start.to_time )/ 60}.first.to_i

	# 					total_working_time.push(  minutes )
	# 				end
	# 			end
	# 		end
	# 	end
	# 	return total_working_time
	# end

	def self.article_x_duration_dibagi_total_working_time(report,hour)
		article_x_duration = Array.new{}
		total_working_time = Array.new{}
		report.detailreports.accumulation_on_that_hour(report,hour).order("created_at ASC").each_with_index do |detailreport, index|
			if detailreport.detailreportarticles != []
				detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data|

					if Article.find_by_name(data[0]) != nil && Report.if_not_breaking_time(report,hour)[0] #data[5].strftime("%H").to_i != 12
						article = Article.find_by_name(data[0])
						article_x_duration.push(  data[2] * article.duration )

						#minutes = WorkingDay.find_by(:name=>report.tanggal.strftime("%A")).working_hours.where.not(:working_state=>"Break").where(:start=>hour).map{|i|  (i.end.to_time-i.start.to_time )/ 60}.first.to_i

					end
				end
			end

			minutes = (detailreport.jam_end.to_time - detailreport.jam.to_time )/60
			total_working_time.push(  minutes )

		end
		return [article_x_duration,total_working_time]
	end

	def self.efficiency(report,hour)
		begin

			article_x_duration_dibagi_total_working_time = Report.article_x_duration_dibagi_total_working_time(report,hour)

			if article_x_duration_dibagi_total_working_time[1] != nil && article_x_duration_dibagi_total_working_time[0] != nil && Report.if_not_breaking_time(report,hour)[0] #hour.to_i != 12
				return "#{ ((article_x_duration_dibagi_total_working_time[0].sum / ( article_x_duration_dibagi_total_working_time[1].sum * report.detailreports.last.opr ) ) * 100) .round(2) }%".html_safe
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.percent(report,hour)
		begin
			#if hour.to_i != 12
			if Report.if_not_breaking_time(report,hour)[0]
				return ((report.detailreports.accumulation_on_that_hour(report,hour).sum(:act) / report.detailreports.accumulation_on_that_hour(report,hour).sum(:target) .to_f * 100 ).to_i ).to_s + "%"
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.pph(report,hour)
		begin
			total_working_time = Report.article_x_duration_dibagi_total_working_time(report,hour)[1]
			#if hour.to_i != 12
			if Report.if_not_breaking_time(report,hour)[0]
				return (report.detailreports.accumulation_on_that_hour(report,hour).sum(:act) / (report.detailreports.accumulation_on_that_hour(report,hour).last.opr * ( (total_working_time.sum/60 .to_f ).round(2) ) ) .to_f ).round(2)
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.rft(report,hour)
		begin
			#if hour.to_i != 12
			if Report.if_not_breaking_time(report,hour)[0]
				return ((report.detailreports.accumulation_on_that_hour(report,hour).sum(:act) / ( report.detailreports.accumulation_on_that_hour(report,hour).sum(:act) + Report.total_defect(report,hour) ) .to_f * 100 ).to_i ).to_s + "%"
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.article(detailreport)
		begin
			if detailreport.detailreportarticles != [] && Report.if_not_breaking_time(detailreport.report,detailreport.jam)[0] #detailreport.jam != 12
				return detailreport.detailreportarticles.map{|i| i.article.to_s + "<font color=red> (act:" + i.output.to_s + ")" + " (opt:" + i.operator.to_s + ")</font>" }.join(", <br>").html_safe
			else
				return '-'
			end
		rescue
			return 0
		end
	end


	############### OTOMATISASI SETIAP JAM ##########

	def self.get_data(user)
		data = user.line.reports.find_by("tanggal = ?",Date.today)

		@opr = data.detailreports.last.opr
		@remark = data.detailreports.last.remark
		@article = data.detailreports.last.article
		@po = data.detailreports.last.po
		@mfg = data.detailreports.last.mfg
		@category = data.detailreports.last.category
		@country = data.detailreports.last.country

		if if_not_breaking_time(data,Time.now)[0] == true #jika bukan break time
				@target = data.detailreports.where("target != ?",0).last.target
		else #jika break time
			@target = 0
		end

		# if [12,16,17,18,19,20].include? hour.to_i  #jam dimana target set ke 0
		# 	@target = 0
		# elsif hour.to_i == 13
		# 	if data.detailreports.offset(1).last == nil
		# 		@target = 0
		# 	else
		# 		@target = data.detailreports.offset(1).last.target
		# 	end
		# else
		# 	@target = data.detailreports.last.target
		# end
	end


	def self.hourly_per_user(user_id) #dari tablet setiap jam manggil
		begin
			user = User.find(user_id)

			Report.get_data(user)

			hour = Report.check_working_hour

		rescue
			puts "still empty"
			return false
		end

			user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create(:jam=>hour[0], :jam_end=>hour[1] , :opr=>@opr, :remark=>@remark, :target=>@target, :article=>@article, :po=>@po, :mfg=>@mfg, :category=>@category, :country=>@country, :defect_int=>Detailreport.empty_defect[0],:defect_ext=>Detailreport.empty_defect[1])
			return true

	end

	def self.hourly #dari cron tiap menit

		User.where("status = ? and role = ?",true,"User").each_with_index do |user,index|
			begin
				report = user.line.reports.find_by("tanggal = ?",Date.today)

				if report.detailreports.last.jam.to_i >= Time.now.strftime("%H").to_i
					puts "Sudah ada!(user aktif) user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				else
					Report.get_data(user)

					hour = Report.check_working_hour

					report.detailreports.create!(:jam=>hour[0], :jam_end=>hour[1] , :opr=>@opr, :remark=>@remark, :target=>@target, :article=>@article, :po=>@po, :mfg=>@mfg, :category=>@category, :country=>@country, :defect_int=>Detailreport.empty_defect[0],:defect_ext=>Detailreport.empty_defect[1])

					puts "Sukses ! user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				end
			rescue Exception => e
				puts "errornya: #{e.message}, user: #{user.email}"
			end
		end
	end

	private

	def self.check_working_hour

		WorkingDay.find_by(:name=>Date.today.strftime("%A")).working_hours.each_with_index do |hour, index|

			if Time.now.between?(hour.start.to_time,hour.end.to_time-1)
				return [hour.start,hour.end]
				break
			end
		end

		raise "diluar jam kerja.."

	end

	def self.total_defect(report,hour)
		return Report.total_defect_int(report,hour)+ Report.total_defect_ext(report,hour)
	end

	def self.total_defect_int(report,hour)
		return merge_defect(report.detailreports.accumulation_on_that_hour(report,hour), "Internal").map{ |k,v| v }.sum
		# return report.detailreports.accumulation_on_that_hour(report,hour).sum("defect_int + defect_int_11b + defect_int_11c + defect_int_11j + defect_int_11l + defect_int_13d").to_i
	end

	def self.total_defect_ext(report,hour)
		return merge_defect(report.detailreports.accumulation_on_that_hour(report,hour), "External").map{ |k,v| v }.sum
		# return report.detailreports.accumulation_on_that_hour(report,hour).sum("defect_ext + defect_ext_bs3 + defect_ext_bs7 + defect_ext_bs13 + defect_ext_bs15 + defect_ext_bs17").to_i
	end

	def self.merge_defect(detailreports, type)
		defect = {}
		detailreports.each do |detailreport|
			if type == "Internal"
				defect = defect.merge(JSON.parse(detailreport.defect_int)){ |key, oldval, newval| oldval+newval }
			else
				defect = defect.merge(JSON.parse(detailreport.defect_ext)){ |key, oldval, newval| oldval+newval }
			end
		end
		return defect
	end

end
