class ArticlesController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer
	add_breadcrumb "Articles", :articles_path

	def index
		#@articles = Article.all
		respond_to do |format|
	      format.html
	      format.js
	      format.json { render json: ArticleDatatable.new(view_context) }
	    end
	end

	def show
		@article = Article.find(params[:id])
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(my_sanitizer)
		respond_to do |format|
	      if @article.save!
	        format.html { redirect_to articles_path, notice: 'Article has been added'}
	        format.json { render action: 'new', status: :created, location: @article }
	      else
	        flash.now.alert = @article.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @article.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
	    respond_to do |format|
	      if @article.update(my_sanitizer)
	        format.html { redirect_to articles_path, notice: 'Article has been updated'}
	        format.json { render action: 'new', status: :created, location: @article }
	      else
	        flash.now.alert = @article.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @article.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@article = Article.find(params[:id])
		if Detailreportarticle.find_by(:article=>@article.name) == nil
			@article.destroy!
			redirect_to articles_path
			flash[:notice] = "Article has been deleted"
		else
			redirect_to articles_path
			flash[:alert] = "Article already used and cant be deleted"
		end


	end

	private

	def my_sanitizer
		params.require(:article).permit!
	end
end
