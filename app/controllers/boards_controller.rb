class BoardsController < ApplicationController
	load_and_authorize_resource


	def index
		@boards = Line.all
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

