class UsersController < ApplicationController
load_and_authorize_resource param_method: :my_sanitizer

	
	def index
		@users = User.all
	end

	def show

	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(my_sanitizer)
		respond_to do |format|
	      if @user.save
	        format.html { redirect_to users_path, notice: 'User has been added'}
	        format.json { render action: 'new', status: :created, location: @user }
	      else
	        flash.now.alert = @user.errors.full_messages.to_sentence
	        format.html { render action: "new" }
	        format.json { render json: @user.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
	    respond_to do |format|
	      if @user.update(my_sanitizer)
	        format.html { redirect_to users_path, notice: 'User has been updated'}
	        format.json { render action: 'new', status: :created, location: @user }
	      else
	        flash.now.alert = @user.errors.full_messages.to_sentence
	        if params[:status] == "reset"
	        	params[:reset_password] = "true"
	        end
	        format.html { render action: "new" }
	        format.json { render json: @user.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def destroy
		@user = User.find(params[:id])
		@user.destroy
		flash[:alert] = "User has been deleted"
		redirect_to users_path
	end



private
	def my_sanitizer
		params.require(:user).permit!
	end
end