class Board < ActiveRecord::Base

	def self.send_email

		if Report.find_by(:tanggal=>Time.now.to_date) == nil #jika tidak ada report sama sekali pada hari tsb
			#nothing
		else
			UserMailer.report(Time.now.to_date).deliver
		end
			
	end

	def self.remove
		begin
			FileUtils.rm_rf(Dir.glob("#{Rails.root}/log/*"))
		rescue
		end
	end

end
