class Board < ActiveRecord::Base

	def self.send_email
			UserMailer.report.deliver
	end

	# def self.remove
			
	# end

end
