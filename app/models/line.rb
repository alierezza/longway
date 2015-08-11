class Line < ActiveRecord::Base

	has_many :reports, :dependent => :destroy
	belongs_to :user

	validates :user_id, :presence=>true, :uniqueness=>true
	validates :no, :presence=>true, :uniqueness=>true

end
