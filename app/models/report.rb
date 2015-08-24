class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	
	def self.hourly
		User.where("status = ? and role = ?",true,"User").each_with_index do |user,index|
			begin
				if user.line.reports.last.detailreports.last.jam.to_i == Time.now.strftime("%H").to_i
					puts "Sudah ada!(user aktif) user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				else
					opr = user.line.reports.last.detailreports.last.opr
					remark = user.line.reports.last.detailreports.last.remark
					percent = user.line.reports.last.detailreports.last.percent
					act_sum = user.line.reports.last.detailreports.sum("act").to_i
					pph = opr == 0 ? 0 : (act_sum / opr  .to_f * (user.line.reports.last.detailreports.count+1) ).round(2)
					rft = user.line.reports.last.detailreports.last.rft
					target = user.line.reports.last.detailreports.last.target
					user.line.reports.last.detailreports.create!(:jam=>Time.now.strftime("%H").to_i, :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark, :target=>target)
					puts "Sukses ! user: #{user.email}, waktu: #{Time.now.strftime("%d %m %Y %H:%M:%S")}"
				end
			rescue Exception => e
				puts "errornya: #{e.message}, user: #{user.email}"
			end
		end
	end

end
