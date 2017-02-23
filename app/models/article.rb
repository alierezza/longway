class Article < ActiveRecord::Base

	validates :name, :presence=>true, :uniqueness=>true
	validates :duration, :presence=>true


	def name=(val)
	    write_attribute :name, val.upcase
	end
end
