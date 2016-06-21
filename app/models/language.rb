class Language < ActiveRecord::Base

	validates :message, :presence=>true, :uniqueness=>true
	validates :foreign_language, :presence=>true, :uniqueness=>false

end
