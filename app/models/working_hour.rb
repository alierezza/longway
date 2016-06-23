class WorkingHour < ActiveRecord::Base
  default_scope { order("start asc") }

  belongs_to :working_day

  validates_uniqueness_of :start, :scope => [:end,:working_day_id]
  validate :check_validation, :duration, :start_must_be_before_end_time

  def self.state
  	["Work", "Break", "Overtime"]
  end

  def check_validation
    self.working_day.working_hours.where.not(id: nil).each do |hour|
    	if self.start.to_time.between?(hour.start.to_time+1, hour.end.to_time-1)
    		errors.add(:base, 'Start should not be between another scheduled time.')
    		break
    	elsif self.end.to_time.between?(hour.start.to_time+1, hour.end.to_time-1)
        errors.add(:base, 'End should not be between another scheduled time.')
        break
      end
    end
	end

	def start_must_be_before_end_time
		if self.end.to_time <= self.start.to_time
			errors.add(:base, 'Wrong time.')
		end
	end

	def duration
		if ((self.end.to_time - self.start.to_time) / 60 ).to_i > 60 ||
			((self.end.to_time - self.start.to_time) / 60 ).to_i < 30
			errors.add(:base, 'Time duration should be 30 - 60 minutes.')
		end
	end
end
