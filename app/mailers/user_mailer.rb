class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	#default from: CONFIG["email_dari"]
  	default from: "dynamic-billboard@id.longwaycorp.com"

  	def report
  		@temp = Array.new
	    Masteremail.all.each_with_index do |email,index|
	    	@temp.push(email.name)
	    end
	    @temp.join(",")

	    mail(to: @temp, subject: "[Global Way Indonesia] Laporan Hasil Produksi Harian (#{Date.today.strftime('%d %B %Y')})")
  	end

end
