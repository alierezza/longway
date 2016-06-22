class WorkingDay < ActiveRecord::Base
	has_many :working_hours, :dependent=>:destroy

	validates_uniqueness_of :name

	def self.working_duration(detailreport)
		detailreport.jam+" - "+detailreport.jam_end
	end
end
