class AdsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		if Ad.count == 0
			redirect_to new_ad_path
		else
			redirect_to edit_ad_path(Ad.first.id)
		end
	end

	def new
		@running_text = Ad.new
	end

	def create
		@running_text = Ad.new(my_sanitizer)
		respond_to do |format|
	      if @running_text.save
	        format.html { redirect_to edit_ad_path(Ad.first.id), notice: 'Data has been added'}
	        format.json { render action: 'new', status: :created, location: @running_text }
	      else
	        flash.now.alert = @running_text.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @running_text.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@running_text = Ad.find(params[:id])
	end

	def update
		@running_text = Ad.find(params[:id])
	    respond_to do |format|
	      if @running_text.update(my_sanitizer)
	        format.html { redirect_to ads_path(Ad.first.id), notice: 'Data has been updated'}
	        format.json { render action: 'new', status: :created, location: @running_text }
	      else
	        flash.now.alert = @running_text.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @running_text.errors, status: :unprocessable_entity }
	      end
	    end
	end

private
	def my_sanitizer
		params.require(:ad).permit!
	end
end
