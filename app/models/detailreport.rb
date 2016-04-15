class Detailreport < ActiveRecord::Base

	belongs_to :report

	has_many :detailreportarticles, :dependent=>:destroy

	validates_uniqueness_of :report_id, :scope => :jam

	validates :article, presence: true, on: :create
	validates :opr, presence: true, on: :create


	validate :check_article

	def check_article
		if Article.find_by_name(self.article) == nil
			self.errors.add(:created_on, "is invalid")
		else
			begin
				data = self.detailreportarticles.find_or_create_by(:article=>self.article)

				if self.act == self.act_was
					output = data.output
				else
					output = data.output + 1
				end

				data.update(:operator=>self.opr,:output=>output)
			rescue
			end

			return true
		end
	end


	def article=(val)
	    write_attribute :article, val.upcase
	end




	
end
