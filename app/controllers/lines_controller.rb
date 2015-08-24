class LinesController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		if params[:visible]
			Line.find(params[:line_no]).update!(:visible=>params[:visible])
		else
			@lines = Line.all
		end
	end

	def show

	end

	def new
		@line = Line.new
	end

	def create
		@line = Line.new(my_sanitizer)
		respond_to do |format|
	      if @line.save
	      	user = User.find(params[:line][:user_id])
	        user.status = true
	        user.save
	        format.html { redirect_to lines_path, notice: 'Line has been added'}
	        format.json { render action: 'new', status: :created, location: @line }
	      else
	        flash.now.alert = @line.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @line.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@line = Line.find(params[:id])
	end

	def update
		@line = Line.find(params[:id])
		#@temp = @line.user.id
	    respond_to do |format|
	      if @line.update(my_sanitizer)
	      	user = @line.user
	        user.status = true
	        user.save
	        #User.find(@temp).update!(:status=>false)
	        format.html { redirect_to lines_path, notice: 'Line has been updated'}
	        format.json { render action: 'new', status: :created, location: @line }
	      else
	        flash.now.alert = @line.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @line.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def destroy
		@line = Line.find(params[:id])
		@line.destroy
		flash[:alert] = "Line has been deleted"
		redirect_to lines_path
	end



private
	def my_sanitizer
		params.require(:line).permit!
	end
end