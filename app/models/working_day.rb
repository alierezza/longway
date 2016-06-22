class WorkingDay < ActiveRecord::Base
	has_many :working_hours

	validates_uniqueness_of :name

	def self.working_duration(detailreport)
		detailreport.jam+" - "+WorkingDay.find_by(:name=>detailreport.report.tanggal.strftime("%A")).working_hours.find_by(:start=>detailreport.jam).end
	end
end
