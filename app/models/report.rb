class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line_id, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	#### PERHITUNGAN #########

	def self.total_working_time_in_minutes(report,hour)
		total_working_time = Array.new{}
		report.detailreports.accumulation_on_that_hour(hour).order("created_at ASC").each_with_index do |detailreport, index|
			if detailreport.detailreportarticles != [] 
				detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data| 
				
					if Article.find_by_name(data[0]) != nil && data[5].strftime("%H").to_i != 12
						if data[5].strftime("%H").to_i >= 16
							if data[5].strftime("%M").to_i < 30 
								minutes = 30 
							else
								minutes = 60 
							end
						elsif data[5].strftime("%H").to_i == 11 && Time.now.friday?
							minutes = 30
						else 
							minutes = 60 
						end
						total_working_time.push(  minutes ) 
					end
				end 
			end
		end
		return total_working_time
	end

	def self.article_x_duration(report,hour)
		article_x_duration = Array.new{}
		report.detailreports.accumulation_on_that_hour(hour).order("created_at ASC").each_with_index do |detailreport, index|
			if detailreport.detailreportarticles != [] 
				detailreport.detailreportarticles.map{|i| [i.article, i.operator, i.output , i.created_at, i.updated_at, i.updated_at ] }.each do |data| 
				
					if Article.find_by_name(data[0]) != nil && data[5].strftime("%H").to_i != 12
						article = Article.find_by_name(data[0])
						article_x_duration.push(  data[2] * article.duration )
					end
				end 
			end
		end
		return article_x_duration
	end

	def self.efficiency(report,hour) 
		begin
			total_working_time = Report.total_working_time_in_minutes(report,hour)
			article_x_duration = Report.article_x_duration(report,hour)

			if total_working_time != nil && article_x_duration != nil && hour.to_i != 12
				return "#{ ((article_x_duration.sum / ( total_working_time.sum * report.detailreports.last.opr ) ) * 100) .round(2) }%".html_safe 
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.percent(report,hour)
		begin
			if hour.to_i != 12
				return ((report.detailreports.accumulation_on_that_hour(hour).sum(:act) / report.detailreports.accumulation_on_that_hour(hour).sum(:target) .to_f * 100 ).to_i ).to_s + "%"
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.pph(report,hour)
		begin
			total_working_time = Report.total_working_time_in_minutes(report,hour)
			if hour.to_i != 12
				return (report.detailreports.accumulation_on_that_hour(hour).sum(:act) / (report.detailreports.accumulation_on_that_hour(hour).last.opr * ( (total_working_time.sum/60 .to_f ).round(2) ) ) .to_f ).round(2)
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.rft(report,hour)
		begin
			if hour.to_i != 12
				return ((report.detailreports.accumulation_on_that_hour(hour).sum(:act) / ( report.detailreports.accumulation_on_that_hour(hour).sum(:act) + Report.total_defect(report,hour) ) .to_f * 100 ).to_i ).to_s + "%"
			else
				return '-'
			end
		rescue
			return 0
		end
	end

	def self.article(detailreport)
		begin
			if detailreport.detailreportarticles != [] && detailreport.jam != 12
				return detailreport.detailreportarticles.map{|i| i.article.to_s + "<font color=red> (act:" + i.output.to_s + ")" + " (opt:" + i.operator.to_s + ")</font>" }.join(", <br>").html_safe 
			else 
				return '-'
			end
		rescue
			return 0
		end
	end


	############### OTOMATISASI SETIAP JAM ##########

	def self.get_data(user,hour)
		data = user.line.reports.find_by("tanggal = ?",Date.today)

		@opr = data.detailreports.last.opr
		@remark = data.detailreports.last.remark
		@article = data.detailreports.last.article
		@po = data.detailreports.last.po
		@mfg = data.detailreports.last.mfg
		@category = data.detailreports.last.category
		@country = data.detailreports.last.country

		if [12,16,17,18,19,20].include? hour.to_i  #jam dimana target set ke 0
			@target = 0
		elsif hour.to_i == 13
			if data.detailreports.offset(1).last == nil 
				@target = 0
			else
				@target = data.detailreports.offset(1).last.target
			end
		else
			@target = data.detailreports.last.target
		end
	end

	
	def self.hourly_per_user(user_id,hour) #dari tablet setiap jam manggil
		begin
			user = User.find(user_id)

			Report.get_data(user,hour)

		rescue
			puts "still empty"
			return false
		end

			user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create(:jam=>hour, :opr=>@opr, :remark=>@remark, :target=>@target, :article=>@article, :po=>@po, :mfg=>@mfg, :category=>@category, :country=>@country)
			return true
		
	end

	def self.hourly #dari cron tiap menit

		User.where("status = ? and role = ?",true,"User").each_with_index do |user,index|
			begin
				if user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.jam.to_i >= Time.now.strftime("%H").to_i
					puts "Sudah ada!(user aktif) user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				else
					hour = Time.now.strftime("%H").to_i
					
					Report.get_data(user,hour)

					user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create!(:jam=>hour, :opr=>@opr, :remark=>@remark, :target=>@target, :article=>@article, :po=>@po, :mfg=>@mfg, :category=>@category, :country=>@country)
					
					puts "Sukses ! user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				end
			rescue Exception => e
				puts "errornya: #{e.message}, user: #{user.email}"
			end
		end
	end

	private

	def self.total_defect(report,hour)
		return Report.total_defect_int(report,hour)+ Report.total_defect_ext(report,hour)
	end

	def self.total_defect_int(report,hour)
		return report.detailreports.accumulation_on_that_hour(hour).sum("defect_int + defect_int_11b + defect_int_11c + defect_int_11j + defect_int_11l + defect_int_13d").to_i
	end

	def self.total_defect_ext(report,hour)
		return report.detailreports.accumulation_on_that_hour(hour).sum("defect_ext + defect_ext_bs3 + defect_ext_bs7 + defect_ext_bs13 + defect_ext_bs15 + defect_ext_bs17").to_i
	end

end
