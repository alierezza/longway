class Detailreport < ActiveRecord::Base

	belongs_to :report

	has_many :detailreportarticles, :dependent=>:destroy

	validates_uniqueness_of :report_id, :scope => :jam

	validates :article, presence: true, on: :create
	validates :opr, presence: true, on: :create

	validates :jam, presence: true
	validates :jam_end, presence: true


	 validate :check_article

	 def check_article
	 	if Article.find_by_name(self.article) == nil
	 		self.errors.add(:created_on, "is invalid")
	# 	else
	# 		begin
	# 			data = self.detailreportarticles.find_or_create_by(:article=>self.article)

	# 			if self.act == self.act_was
	# 				output = data.output
	# 			else
	# 				output = data.output + 1
	# 			end

	# 			data.update(:operator=>self.opr,:output=>output)
	# 		rescue
	# 		end

	# 		return true
	 	end
	 end


	def article=(val)
	    write_attribute :article, val.upcase
	end


	after_save :create_new_detailreportarticle

	def create_new_detailreportarticle

		if Article.find_by_name(self.article) == nil
			self.errors.add(:created_on, "is invalid")
		else
			begin
				data = self.detailreportarticles.find_or_create_by(:article=>self.article)

				if self.act == self.act_was && data.output != 0 #jika defect yg ditekan dan act bukan 0
					#output = self.act_was
					output = data.output
				else #jika act adalah 0
					if self.detailreportarticles.count > 1
						output = self.act - self.detailreportarticles.where("id != ?",data.id).sum(:output)
					else
						output = self.act
					end
				end

				data.update(:operator=>self.opr,:output=>output)
			rescue
			end

			return true
		end

	end

	def self.accumulation_on_that_hour(report,hour)
		where("jam <= ?",hour).where.not(:jam=>WorkingDay.find_by(:name=>report.tanggal.strftime("%A")).working_hours.where(:working_state=>"Break").pluck(:start))
	end

	def self.empty_defect
		defect_int = Defect.where(defect_type: "Internal").pluck(:name)
		defect_int = defect_int.map{ |a| [a, 0] }.to_h

		defect_ext = Defect.where(defect_type: "External").pluck(:name)
		defect_ext = defect_ext.map{ |a| [a, 0] }.to_h


    	return [defect_int.to_json,defect_ext.to_json]
	end

	
end
