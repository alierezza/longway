class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	validates :line, :presence=>true, :uniqueness=>{scope: :tanggal}

	accepts_nested_attributes_for :detailreports, allow_destroy: true

	
end
