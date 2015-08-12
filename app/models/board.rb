class Board < ActiveRecord::Base

	def self.send_email
			UserMailer.report.deliver
	end

end
