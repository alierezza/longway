class Defect < ActiveRecord::Base
	validate :defect_count_within_limit, on: :create

	def self.type
		["Internal", "External"]
	end

	def defect_count_within_limit
	    if Defect.where(defect_type: self.defect_type).count >= 6
	      	errors.add(:base, 'Exceeded defect limit')
	    end
	end
end
