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
			begin
				
				if current_user.line.reports.last.detailreports.last.jam.to_i == Time.now.strftime("%H").to_i

				else
					opr = User.find(params[:user_id]).line.reports.last.detailreports.last.opr
					remark = User.find(params[:user_id]).line.reports.last.detailreports.last.remark
					act_sum = User.find(params[:user_id]).line.reports.last.detailreports.sum("act").to_i
					
					rft = User.find(params[:user_id]).line.reports.last.detailreports.last.rft
					
					
					time = Time.now.strftime("%H").to_i

					if time == 12 
						pph = opr == 0 ? 0 : (act_sum / ( opr * (User.find(params[:user_id]).line.reports.last.detailreports.count) ) .to_f ).round(2)
						target = 0
						target_sum = User.find(params[:user_id]).line.reports.last.detailreports.sum("target").to_i
					elsif time == 16 or time == 17
						pph = opr == 0 ? 0 : (act_sum / ( opr * (User.find(params[:user_id]).line.reports.last.detailreports.where("jam != ?",12).count+1) ) .to_f ).round(2)
						target = 0
						target_sum = User.find(params[:user_id]).line.reports.last.detailreports.sum("target").to_i
					else
						pph = opr == 0 ? 0 : (act_sum / ( opr * (User.find(params[:user_id]).line.reports.last.detailreports.where("jam != ?",12).count+1) ) .to_f ).round(2)
						if time == 13
							target = User.find(params[:user_id]).line.reports.last.detailreports.offset(1).last.target
						else
							target = User.find(params[:user_id]).line.reports.last.detailreports.last.target
						end
						target_sum = User.find(params[:user_id]).line.reports.last.detailreports.sum("target").to_i + target.to_i
					end
					percent = target_sum == 0 ? 0 : ((act_sum / target_sum .to_f) *100 ).round(0)
					User.find(params[:user_id]).line.reports.last.detailreports.create!(:jam=>params[:record], :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark, :target=>target)
					
				end
			rescue Exception => e

			end
		end
	end

	def create
		if Time.now.strftime("%H").to_i != 12
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

			params[:report][:detailreports_attributes]["0"][:percent] = params[:report][:detailreports_attributes]["0"][:target].to_i == 0 ? 0 : ((params[:report][:detailreports_attributes]["0"][:act].to_i / params[:report][:detailreports_attributes]["0"][:target].to_i .to_f )* 100 ).round(0)
			params[:report][:detailreports_attributes]["0"][:pph] = params[:report][:detailreports_attributes]["0"][:opr].to_i == 0 ? 0 : (params[:report][:detailreports_attributes]["0"][:act].to_i / params[:report][:detailreports_attributes]["0"][:opr].to_i .to_f).round(2)
			defact = params[:report][:detailreports_attributes]["0"][:defect_int].to_i+params[:report][:detailreports_attributes]["0"][:defect_ext].to_i .to_f
			temp = params[:report][:detailreports_attributes]["0"][:act].to_i == 0 ? 0 :  params[:report][:detailreports_attributes]["0"][:act].to_i / ( params[:report][:detailreports_attributes]["0"][:act].to_i  + defact ) .to_f
			params[:report][:detailreports_attributes]["0"][:rft] = temp == 0 ? 0 : ( temp * 100 .to_f).round(0)

			@report = current_user.line.reports.new(my_sanitizer)
		    @report.save!
		end
	end

	def edit
		#@report = Report.find(params[:id])
	end

	def update
		
		jam = Time.now.strftime("%H").to_i
		detailreport_id = params[:report][:detailreports_attributes]["0"][:id].to_i

		if jam != 12 and Detailreport.find(detailreport_id).jam == Time.now.strftime("%H").to_i
			@report = Report.find(params[:id])

			if params[:status] == "actual"
				params[:report][:detailreports_attributes]["0"][:act] = @report.detailreports.find(detailreport_id).act.to_i + 1
				#params[:report][:detailreports_attributes]["0"][:act_sum] = @report.detailreports.last.sum.to_i + 1
			elsif params[:status] == "int_defect"
				params[:report][:detailreports_attributes]["0"][:defect_int] = @report.detailreports.find(detailreport_id).defect_int.to_i + 1
			elsif params[:status] == "ext_defect"
				params[:report][:detailreports_attributes]["0"][:defect_ext] = @report.detailreports.find(detailreport_id).defect_ext.to_i + 1
			end

			params[:report][:detailreports_attributes]["0"][:opr] != nil ? opr = params[:report][:detailreports_attributes]["0"][:opr].to_i : opr = @report.detailreports.find(detailreport_id).opr.to_i

			params[:report][:detailreports_attributes]["0"][:act] != nil ? act = params[:report][:detailreports_attributes]["0"][:act].to_i : act = @report.detailreports.find(detailreport_id).act.to_i

			params[:report][:detailreports_attributes]["0"][:target] != nil ? target = params[:report][:detailreports_attributes]["0"][:target].to_i : target = @report.detailreports.find(detailreport_id).target.to_i

			params[:report][:detailreports_attributes]["0"][:defect_int] != nil ? defect_int = params[:report][:detailreports_attributes]["0"][:defect_int].to_i + @report.detailreports.sum("defect_int").to_i : defect_int = @report.detailreports.sum("defect_int").to_i

			params[:report][:detailreports_attributes]["0"][:defect_ext] != nil ? defect_ext = params[:report][:detailreports_attributes]["0"][:defect_ext].to_i + @report.detailreports.sum("defect_ext").to_i : defect_ext = @report.detailreports.sum("defect_ext").to_i


			act_sum = act + @report.detailreports.sum("act").to_i - @report.detailreports.find(detailreport_id).act.to_i
			#if @report.detailreports.count == 1
			target_sum = target + ( @report.detailreports.sum("target").to_i - @report.detailreports.find(detailreport_id).target.to_i )
			#else
			#	target_sum = target + ( @report.detailreports.sum("target").to_i )
			#end
			defact = defect_int + defect_ext

			params[:report][:detailreports_attributes]["0"][:percent] = target_sum == 0 ? 0 : ((act_sum / target_sum	 .to_f	) * 100).round(0)
			params[:report][:detailreports_attributes]["0"][:pph] = opr == 0 ? 0 : (act_sum / ( opr * (current_user.line.reports.last.detailreports.where("jam != ?",12).count) ) .to_f ).round(2)
			params[:report][:detailreports_attributes]["0"][:rft] = act_sum + defact == 0 ? 0 : ( ( ( act_sum / ( act_sum + defact )  .to_f )  .to_f) * 100).round(0)


			#params[:report][:detailreports_attributes]["0"][:target_sum] = params[:report][:detailreports_attributes]["0"][:target].to_i + @report.detailreports.last.target_sum.to_i
		    @report.update!(my_sanitizer)
		end
	end


	def destroy

	end



private
	def my_sanitizer
		params.require(:report).permit!
	end
end