class Defect < ActiveRecord::Base
	validates :name, format: { with: /\A[a-zA-Z0-9\s]+\z/i, message: "Only allows alphanumeric" }, length: { maximum: 8 }
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
