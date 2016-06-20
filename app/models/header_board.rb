class HeaderBoard < ActiveRecord::Base
	include RankedModel
	ranks :order_no

	validates_uniqueness_of :name
end
