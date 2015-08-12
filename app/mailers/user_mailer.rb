class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	default from: CONFIG["email_dari"]

  	def report
	    
	    mail(to: CONFIG["email_kirim_ke"],
	         subject: "[Global Way Indonesia] Laporan Harian")
  	end

end
