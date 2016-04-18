class Article < ActiveRecord::Base

	validates :name, :presence=>true, :uniqueness=>true
	validates :duration, :presence=>true

	def self.full_search(keyword)

		keyword.gsub!(/\:/,"")
		keyword.gsub!(/\:\*$/,"")

	    keyword.gsub!(/ +/,"&")

	    keyword.gsub!(/^&+/,"")
	    keyword.gsub!(/&+$/,"")


	    keyword.gsub!(/\|+$/,"")

	    keyword.gsub!(/^ +/,"")
	    keyword.gsub!(/^\|+/,"")

	    keyword = keyword+":*"

	    Article.fix_search(keyword)

	    return keyword
	end

	def self.fix_search(keyword)
	    keyword.split("").each_with_index do |i,index|
	      if keyword[index] == "&" and keyword[index+1]+keyword[index+2]==":*" 
	        keyword.slice!(index)
	        Article.fix_search(keyword)
	      end

	      if keyword[index] == "|" and keyword[index-1]=="&" 
	        keyword.slice!(index-1)
	        Article.fix_search(keyword)
	      end
	      if keyword[index] == "|" and keyword[index+1]=="&" 

	        keyword.slice!(index+1)
	        Article.fix_search(keyword)
	      end
	      if (keyword[index] == "|" || keyword[index] == "&") and keyword[index-2]+keyword[index-1] != ":*"
	        keyword.insert(index,":*")
	        Article.fix_search(keyword)
	      end
	    end
	end
end
