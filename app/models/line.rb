class Line < ActiveRecord::Base

	has_many :reports, :dependent => :destroy
	belongs_to :user




end
