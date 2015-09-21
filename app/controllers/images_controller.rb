class ImagesController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		if params[:id] && (Image.where(:status=>true).count < 5 && params[:status] == "true") || Image.where(:status=>true).count <= 5 && params[:status] == "false"
			@image = Image.find(params[:id])
			@image.status = params[:status]
			@image.save
			@cek = true
		end
		@images = Image.all.order("id")
	end

	def new
		@image = Image.new
	end

	def create
		@image = Image.new(my_sanitizer)
		respond_to do |format|
	      if @image.save
	        format.html { redirect_to images_path, notice: 'Image has been added'}
	        format.json { render action: 'new', status: :created, location: @image }
	      else
	        flash.now.alert = @image.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @image.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@image = Image.find(params[:id])
	end

	def update
		@image = Image.find(params[:id])
	    respond_to do |format|
	      if @image.update(my_sanitizer)
	        format.html { redirect_to images_path, notice: 'Image has been updated'}
	        format.json { render action: 'new', status: :created, location: @image }
	      else
	        flash.now.alert = @image.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @image.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@image = Image.find(params[:id])
		@image.destroy
		flash[:notice] = "Image has been deleted"
		redirect_to images_path
	end

private
	def my_sanitizer
		params.require(:image).permit!
	end

end
