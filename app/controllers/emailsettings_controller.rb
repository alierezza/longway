class EmailsettingsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer
	add_breadcrumb "Email Setting", :emailsettings_path

	def index

	end

	def new

	end

	def create

	end

	def edit
		@emailsetting = Emailsetting.find(params[:id])
	end

	def update
		

		#begin
		#	ActiveRecord::Base.transaction do

		@emailsetting = Emailsetting.find(params[:id])
		if @emailsetting.update(:email_time=>params[:emailsetting][:email_time])
			 %x[ whenever --update-crontab visual_production ]
			flash[:notice] = "Update success"
			redirect_to emailsettings_path
		else
			flash[:alert] = "Update failed"
			redirect_to emailsettings_path
		end

				

			#end
		# rescue
		# 	flash[:alert] = "Update failed"
		# 	redirect_to edit_emailsetting_path(Emailsetting.first)
		# end


	end

end
