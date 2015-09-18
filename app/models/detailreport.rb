class Detailreport < ActiveRecord::Base

	belongs_to :report

	validates_uniqueness_of :report_id, :scope => :jam
end
