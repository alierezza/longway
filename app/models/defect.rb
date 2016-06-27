class Defect < ActiveRecord::Base
	validate :defect_count_within_limit, on: :create
	validates_uniqueness_of :name, :scope => :defect_type

	def self.type
		["Internal", "External"]
	end

	def defect_count_within_limit
	    if Defect.where(defect_type: self.defect_type).count >= 10
	      	errors.add(:base, 'Exceeded defect limit')
	    end
	end
end
