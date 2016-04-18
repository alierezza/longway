class UserMailer < ApplicationMailer
	include Devise::Mailers::Helpers
  	include ApplicationHelper

  	#default from: CONFIG["email_dari"]
  	#default from: "dynamic-billboard@id.longwaycorp.com"
  	default from: "visualboard.gwi@gmail.com"

  	def report(tanggal)
  		
  		@send_to = Array.new
	    Masteremail.all.each_with_index do |email,index|
	    	@send_to.push(email.name)
	    end
	    @send_to = @send_to.join(",")

  		path = Masteremail.generate_excel(tanggal)

	    attachments["Report_#{Time.now.strftime('%d-%m-%Y')}.xls"] = File.read(path)
	    mail(to: @send_to, subject: "[Global Way Indonesia] Daily Production Report (#{Date.today.strftime('%d %B %Y')})")

	    #FileUtils.rm_f(path)
  	
  	end

end
