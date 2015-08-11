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

	def data

		if params[:search]
			@data = Line.where("no=?",params[:no].to_i).first.reports.where("tanggal = ?",params[:tanggal].to_date)
		end

		authorize! :data, current_user
	end

	def show

	end

	def new
		if params[:record]
			opr = current_user.line.reports.last.detailreports.last.opr
			remark = current_user.line.reports.last.detailreports.last.remark
			current_user.line.reports.last.detailreports.create!(:jam=>params[:record], :opr=>opr, :remark=>remark)
		end
	end

	def create
		params[:report][:tanggal] = Date.today
		#params[:report][:detailreports_attributes]["0"][:target_sum] = params[:report][:detailreports_attributes]["0"][:target]
		params[:report][:detailreports_attributes]["0"][:jam] = Time.now.strftime("%H")

		if params[:status] == "actual"
			params[:report][:detailreports_attributes]["0"][:act] = @report.detailreports.last.act.to_i + 1
			#params[:report][:detailreports_attributes]["0"][:act_sum] = @report.detailreports.last.sum.to_i + 1
		elsif params[:status] == "int_defect"
			params[:report][:detailreports_attributes]["0"][:defect_int] = @report.detailreports.last.defect_int.to_i + 1
		elsif params[:status] == "ext_defect"
			params[:report][:detailreports_attributes]["0"][:defect_ext] = @report.detailreports.last.defect_ext.to_i + 1
		end

		@report = current_user.line.reports.new(my_sanitizer)
	    @report.save!
	end

	def edit
		#@report = Report.find(params[:id])
	end

	def update
		@report = Report.find(params[:id])

		if params[:status] == "actual"
			params[:report][:detailreports_attributes]["0"][:act] = @report.detailreports.last.act.to_i + 1
			#params[:report][:detailreports_attributes]["0"][:act_sum] = @report.detailreports.last.sum.to_i + 1
		elsif params[:status] == "int_defect"
			params[:report][:detailreports_attributes]["0"][:defect_int] = @report.detailreports.last.defect_int.to_i + 1
		elsif params[:status] == "ext_defect"
			params[:report][:detailreports_attributes]["0"][:defect_ext] = @report.detailreports.last.defect_ext.to_i + 1
		end

		#params[:report][:detailreports_attributes]["0"][:target_sum] = params[:report][:detailreports_attributes]["0"][:target].to_i + @report.detailreports.last.target_sum.to_i
	    @report.update!(my_sanitizer)
	end


	def destroy

	end



private
	def my_sanitizer
		params.require(:report).permit!
	end
end