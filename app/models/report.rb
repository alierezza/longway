class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line_id, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	
	def self.hourly

		User.where("status = ? and role = ?",true,"User").each_with_index do |user,index|
			begin
				if user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.jam.to_i >= Time.now.strftime("%H").to_i
					puts "Sudah ada!(user aktif) user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				else
					opr = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.opr
					remark = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.remark
					article = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.article
					po = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.po
					mfg = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.mfg
					
					act_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("act").to_i
					rft = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.rft
					
					time = Time.now.strftime("%H").to_i
					if time == 12
						if Time.now.friday? and user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where(:jam=>11).count == 1
							pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.count - 0.5) ) .to_f ).round(2)
						else
							pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.count) ) .to_f ).round(2)
						end

						target = 0
						target_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("target").to_i
					else
						if Time.now.friday? and user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where(:jam=>11).count == 1
							pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where("jam != ?",12).count+1 - 0.5) ) .to_f ).round(2)
						elsif 
							pph = opr == 0 ? 0 : (act_sum / ( opr * (user.line.reports.find_by("tanggal = ?",Date.today).detailreports.where("jam != ?",12).count+1) ) .to_f ).round(2)
						end


						if time == 13
							target = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.offset(1).last == nil ? 0 : user.line.reports.find_by("tanggal = ?",Date.today).detailreports.offset(1).last.target
						else
							target = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.last.target
						end
						
						target_sum = user.line.reports.find_by("tanggal = ?",Date.today).detailreports.sum("target").to_i  + target.to_i
					end
					percent = target_sum == 0 ? 0 : ((act_sum / target_sum .to_f) *100 ).round(0)
					user.line.reports.find_by("tanggal = ?",Date.today).detailreports.create!(:jam=>Time.now.strftime("%H").to_i, :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark, :target=>target, :article=>article, :po=>po, :mfg=>mfg)
					puts "Sukses ! user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				end
			rescue Exception => e
				puts "errornya: #{e.message}, user: #{user.email}"
			end
		end
	end

end
