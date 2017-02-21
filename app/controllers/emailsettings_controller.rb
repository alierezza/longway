class EmailsettingsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer
	add_breadcrumb "Email Setting", :emailsettings_path

	def index
		@emailsettings = Emailsetting.all
	end

	def new
		@emailsetting = Emailsetting.new
	end

	def create	
		@emailsetting = Emailsetting.new(emailsetting_params)
		if @emailsetting.save
			 %x[ whenever --update-crontab visual_production ]
			flash[:notice] = "Update success"
			redirect_to emailsettings_path
		else
			flash[:alert] = "Update failed"
			redirect_to emailsettings_path
		end
	end

	def edit
		@emailsetting = Emailsetting.find(params[:id])
	end

	def update
		

		#begin
		#	ActiveRecord::Base.transaction do

		@emailsetting = Emailsetting.find(params[:id])
		if @emailsetting.update(emailsetting_params)
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

	def destroy
		@emailsetting = Emailsetting.find(params[:id])
		@emailsetting.destroy
	    %x[ whenever --update-crontab visual_production ]
	    respond_to do |format|
	      format.html { redirect_to emailsettings_path, notice: 'Email Setting was successfully destroyed.' }
	      format.json { head :no_content }
	    end

	end

	private
	def emailsetting_params
      params.require(:emailsetting).permit!
    end

end
