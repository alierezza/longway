class EmailsettingsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer
	add_breadcrumb "Email Setting", :edit_emailsetting_path

	def edit
		@emailsetting = Emailsetting.find(Emailsetting.first.id)
	end

	def update
		

		begin
			ActiveRecord::Base.transaction do

				@emailsetting = Emailsetting.find(Emailsetting.first.id)
				if @emailsetting.update(:email_time=>params[:emailsetting][:email_time])

					flash[:notice] = "Update success"
					redirect_to edit_emailsetting_path(Emailsetting.first,:set=>true)
				else
					flash[:alert] = "Update failed"
					redirect_to edit_emailsetting_path(Emailsetting.first)
				end

				

			end
		rescue
			flash[:alert] = "Update failed"
			redirect_to edit_emailsetting_path(Emailsetting.first)
		end


	end

end
