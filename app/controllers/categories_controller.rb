class CategoriesController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer
	add_breadcrumb "Categories", :categories_path

	def index
		respond_to do |format|
	      format.html
	      format.js
	      format.json { render json: CategoryDatatable.new(view_context) }
	    end
	end

	def show
		@category = Category.find(params[:id])
	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(my_sanitizer)
		respond_to do |format|
	      if @category.save!
	        format.html { redirect_to categories_path, notice: 'Category has been added'}
	        format.json { render action: 'new', status: :created, location: @category }
	      else
	        flash.now.alert = @category.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @category.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
	    respond_to do |format|
	      if @category.update(my_sanitizer)
	        format.html { redirect_to categories_path, notice: 'Category has been updated'}
	        format.json { render action: 'new', status: :created, location: @category }
	      else
	        flash.now.alert = @category.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @category.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@category = Category.find(params[:id])
		@category.destroy!
		redirect_to categories_path
		flash[:notice] = "Category has been deleted"
	end

	private

	def my_sanitizer
		params.require(:category).permit!
	end
end
