class CountriesController < ApplicationController
load_and_authorize_resource param_method: :my_sanitizer

	def index
		#@articles = Article.all
		respond_to do |format|
	      format.html
	      format.js
	      format.json { render json: CountryDatatable.new(view_context) }
	    end
	end

	def show
		@country = Country.find(params[:id])
	end

	def new
		@country = Country.new
	end

	def create	
		@country = Country.new(my_sanitizer)
		respond_to do |format|
	      if @country.save!
	        format.html { redirect_to countries_path, notice: 'Country has been added'}
	        format.json { render action: 'new', status: :created, location: @country }
	      else
	        flash.now.alert = @country.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @country.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@country = Country.find(params[:id])
	end

	def update
		@country = Country.find(params[:id])
	    respond_to do |format|
	      if @country.update(my_sanitizer)
	        format.html { redirect_to countries_path, notice: 'Country has been updated'}
	        format.json { render action: 'new', status: :created, location: @country }
	      else
	        flash.now.alert = @country.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @country.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@country = Country.find(params[:id])
		@country.destroy!
		redirect_to countries_path
		flash[:notice] = "Country has been deleted"
	end

	private

	def my_sanitizer
		params.require(:country).permit!
	end
end
