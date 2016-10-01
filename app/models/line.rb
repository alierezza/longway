class Line < ActiveRecord::Base

	has_many :reports, :dependent => :destroy
	belongs_to :user

	validates :user_id, :presence=>true, :uniqueness=>true
	validates :no, :presence=>true, :uniqueness=>true
	validate :defect_count_within_limit, on: :create

	def defect_count_within_limit
	    if Line.all.count >= 45
	      	errors.add(:base, 'Exceeded line limit (max 45 lines)')
	    end
	end
end
