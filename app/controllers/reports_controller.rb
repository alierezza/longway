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
			begin
			@data = Line.where("no=?",params[:no].to_i).first.reports.where("tanggal = ?",params[:tanggal].to_date)
			rescue
				@data = []
			end
		end

		authorize! :data, current_user
	end

	def show

	end

	def new
		if params[:record] #refresh tiap jam
			opr = current_user.line.reports.last.detailreports.last.opr
			remark = current_user.line.reports.last.detailreports.last.remark
			percent = current_user.line.reports.last.detailreports.last.percent
			act_sum = current_user.line.reports.last.detailreports.sum("act").to_i
			pph = opr == 0 ? 0 : (act_sum / opr  .to_f * (current_user.line.reports.last.detailreports.count+1) ).round(2)
			rft = current_user.line.reports.last.detailreports.last.rft
			current_user.line.reports.last.detailreports.create!(:jam=>params[:record], :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark)
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

		params[:report][:detailreports_attributes]["0"][:percent] = params[:report][:detailreports_attributes]["0"][:target].to_i == 0 ? 0 : (params[:report][:detailreports_attributes]["0"][:act].to_i / params[:report][:detailreports_attributes]["0"][:target].to_i .to_f ).round(2)
		params[:report][:detailreports_attributes]["0"][:pph] = params[:report][:detailreports_attributes]["0"][:opr].to_i == 0 ? 0 : (params[:report][:detailreports_attributes]["0"][:act].to_i / params[:report][:detailreports_attributes]["0"][:opr].to_i .to_f).round(2)
		defact = params[:report][:detailreports_attributes]["0"][:defect_int].to_i+params[:report][:detailreports_attributes]["0"][:defect_ext].to_i .to_f
		temp = params[:report][:detailreports_attributes]["0"][:act].to_i == 0 ? 0 :  params[:report][:detailreports_attributes]["0"][:act].to_i / ( params[:report][:detailreports_attributes]["0"][:act].to_i  + defact ) .to_f
		params[:report][:detailreports_attributes]["0"][:rft] = temp == 0 ? 0 : ( temp  .to_f).round(2)

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

		params[:report][:detailreports_attributes]["0"][:opr] != nil ? opr = params[:report][:detailreports_attributes]["0"][:opr].to_i : opr = @report.detailreports.last.opr.to_i

		params[:report][:detailreports_attributes]["0"][:act] != nil ? act = params[:report][:detailreports_attributes]["0"][:act].to_i : act = @report.detailreports.last.act.to_i

		params[:report][:detailreports_attributes]["0"][:target] != nil ? target = params[:report][:detailreports_attributes]["0"][:target].to_i : target = @report.detailreports.last.target.to_i

		params[:report][:detailreports_attributes]["0"][:defect_int] != nil ? defect_int = params[:report][:detailreports_attributes]["0"][:defect_int].to_i + @report.detailreports.sum("defect_int").to_i : defect_int = @report.detailreports.sum("defect_int").to_i

		params[:report][:detailreports_attributes]["0"][:defect_ext] != nil ? defect_ext = params[:report][:detailreports_attributes]["0"][:defect_ext].to_i + @report.detailreports.sum("defect_ext").to_i : defect_ext = @report.detailreports.sum("defect_ext").to_i


		act_sum = act + @report.detailreports.sum("act").to_i - @report.detailreports.last.act.to_i
		#if @report.detailreports.count == 1
		target_sum = target + ( @report.detailreports.sum("target").to_i - @report.detailreports.last.target.to_i )
		#else
		#	target_sum = target + ( @report.detailreports.sum("target").to_i )
		#end
		defact = defect_int + defect_ext

		params[:report][:detailreports_attributes]["0"][:percent] = target_sum == 0 ? 0 : (act_sum / target_sum	 .to_f	).round(2)
		params[:report][:detailreports_attributes]["0"][:pph] = opr == 0 ? 0 : (act_sum / opr  .to_f * (current_user.line.reports.last.detailreports.count) ).round(2)
		params[:report][:detailreports_attributes]["0"][:rft] = act_sum + defact == 0 ? 0 : ( ( act_sum / ( act_sum + defact )  .to_f )  .to_f).round(2)


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