class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	
	def self.hourly
		User.where("status = true").each_with_index do |user,index|
			opr = user.line.reports.last.detailreports.last.opr
			remark = user.line.reports.last.detailreports.last.remark
			percent = user.line.reports.last.detailreports.last.percent
			act_sum = user.line.reports.last.detailreports.sum("act").to_i
			pph = opr == 0 ? 0 : (act_sum / opr  .to_f * (user.line.reports.last.detailreports.count+1) ).round(2)
			rft = user.line.reports.last.detailreports.last.rft
			user.line.reports.last.detailreports.create!(:jam=>params[:record], :opr=>opr,:percent=>percent,:pph=>pph,:rft=>rft, :remark=>remark)
		end
	end

end
