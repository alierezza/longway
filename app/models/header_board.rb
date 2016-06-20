class HeaderBoard < ActiveRecord::Base
	include RankedModel
	ranks :order_no
end
