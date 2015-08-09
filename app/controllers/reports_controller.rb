class ReportsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		if params[:message]
			status = params[:message].split("_")[0]
			id = params[:message].split("_")[1]

			status == "on" ? status = false : status = true

			Line.find(id).update!(:status=>status)
		end

		if current_user.line.reports == []
			@target_and_opr = Report.new
			@target_and_opr.detailreports.build
		elsif current_user.line.reports.where("tanggal = ?",Date.today) == []
			@target_and_opr = Report.new
			@target_and_opr.detailreports.build
		else
			@target_and_opr = current_user.line.reports.where("tanggal = ?",Date.today).first
			@target_and_opr.detailreports.last
		end

	end

	def show

	end

	def new

	end

	def create
		params[:report][:tanggal] = Date.today
		params[:report][:detailreports_attributes]["0"][:target_sum] = params[:report][:detailreports_attributes]["0"][:target]
		@report = current_user.line.reports.new(my_sanitizer)
	    @report.save!
	end

	def edit

	end

	def update
		@report = Report.find(params[:id])
		if params[:status]
			params[:report][:detailreports_attributes]["0"][:act] = @report.detailreports.last.act.to_i + 1
			params[:report][:detailreports_attributes]["0"][:act_sum] = @report.detailreports.last.sum.to_i + 1
		end
		
		params[:report][:detailreports_attributes]["0"][:target_sum] = params[:report][:detailreports_attributes]["0"][:target].to_i + @report.detailreports.last.target_sum.to_i
	    @report.update!(my_sanitizer)
	end


	def destroy

	end



private
	def my_sanitizer
		params.require(:report).permit!
	end
end