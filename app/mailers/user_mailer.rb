class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	default from: CONFIG["email_dari"]

  	def report
	    
	    mail(to: CONFIG["kirim_email_ke"],
	         subject: "[Global Way Indonesia] Laporan Hasil Produksi Harian (#{Date.today.strftime('%d %B %Y')})")
  	end

end
