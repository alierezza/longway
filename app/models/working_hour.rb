class WorkingHour < ActiveRecord::Base
  belongs_to :working_day

  def self.state
  	["Work", "Break", "Overtime"]
  end
end
