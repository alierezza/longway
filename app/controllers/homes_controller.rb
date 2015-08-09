class HomesController < ApplicationController
	load_and_authorize_resource

	def index
		if current_user.role == "User"
			redirect_to reports_path
		end
	end

	def show

	end

	def new

	end

	def create

	end

	def edit

	end

	def update

	end


	def destroy

	end



private

end