class Detailreportarticle < ActiveRecord::Base

	belongs_to :detailreport

	validates :detailreport_id, :presence=>true, :uniqueness=>{scope: :article}

end
