class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	default from: CONFIG["email_dari"]

  	def report
	    
	    mail(to: CONFIG["email_kirim_ke"],
	         subject: "Informasi Pendaftaran Akun Portal LTMS Pertamina")
  	end

end
