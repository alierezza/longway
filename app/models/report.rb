class Report < ActiveRecord::Base

	has_many :detailreports, :dependent=>:destroy
	belongs_to :line

	accepts_nested_attributes_for :detailreports, allow_destroy: true
end
