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

  		path = Masteremail.generate_excel(tanggal.to_date)

	    attachments["Report_#{tanggal.to_date.strftime('%d-%m-%Y')}.xls"] = File.read(path)
	    mail(to: @send_to, subject: "[Global Way Indonesia] Daily Production Report (#{tanggal.to_date.strftime('%d %B %Y')})") do |format|
        format.html{
          render locals: {tanggal: tanggal.to_date}
        }
      end

	    #FileUtils.rm_f(path)
  	
  	end

end
