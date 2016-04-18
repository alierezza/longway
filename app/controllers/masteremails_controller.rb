class MasteremailsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		@emails = Masteremail.all

		if params[:tanggal]

			if params[:send_email]

				if Report.find_by(:tanggal=>params[:tanggal].to_date) == nil #jika tidak ada report sama sekali pada hari tsb
					redirect_to masteremails_path
					flash[:alert] = "Data empty"
				elsif Masteremail.all.count <= 0
					redirect_to masteremails_path
					flash[:alert] = "Email List empty"
				else
					UserMailer.report(params[:tanggal].to_date).deliver
					redirect_to masteremails_path
					flash[:notice] = "Email has been sent"
				end


			elsif params[:download_excel]

				if Report.find_by(:tanggal=>params[:tanggal].to_date) == nil #jika tidak ada report sama sekali pada hari tsb
					redirect_to masteremails_path
					flash[:alert] = "Data empty"
				else
					path = Masteremail.generate_excel(params[:tanggal])
					send_file path, :type => "application/vnd.ms-excel", :filename => "data.xls", :stream => false

					#FileUtils.rm(path)
				end

			end
				

			

			
		end	
	end

	def show

	end

	def new
		@email = Masteremail.new
	end

	def create
		@email = Masteremail.new(my_sanitizer)
		respond_to do |format|
	      if @email.save
	        format.html { redirect_to masteremails_path, notice: 'Email has been added'}
	        format.json { render action: 'new', status: :created, location: @email }
	      else
	        flash.now.alert = @email.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @email.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@email = Masteremail.find(params[:id])
	end

	def update
		@email = Masteremail.find(params[:id])
	    respond_to do |format|
	      if @email.update(my_sanitizer)
	        format.html { redirect_to masteremails_path, notice: 'Email has been updated'}
	        format.json { render action: 'new', status: :created, location: @email }
	      else
	        flash.now.alert = @email.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @email.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def destroy
		@email = Masteremail.find(params[:id])
		@email.destroy
		flash[:alert] = "Email has been deleted"
		redirect_to masteremails_path
	end



private
	def my_sanitizer
		params.require(:masteremail).permit!
	end
end
