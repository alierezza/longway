class WorkingDay < ActiveRecord::Base
	has_many :working_hours

	validates_uniqueness_of :name
end
