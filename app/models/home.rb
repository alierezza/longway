class Home < ActiveRecord::Base


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

	    Home.fix_search(keyword)

	    return keyword
	end

	def self.fix_search(keyword)
	    keyword.split("").each_with_index do |i,index|
	      if keyword[index] == "&" and keyword[index+1]+keyword[index+2]==":*" 
	        keyword.slice!(index)
	        Home.fix_search(keyword)
	      end

	      if keyword[index] == "|" and keyword[index-1]=="&" 
	        keyword.slice!(index-1)
	        Home.fix_search(keyword)
	      end
	      if keyword[index] == "|" and keyword[index+1]=="&" 

	        keyword.slice!(index+1)
	        Home.fix_search(keyword)
	      end
	      if (keyword[index] == "|" || keyword[index] == "&") and keyword[index-2]+keyword[index-1] != ":*"
	        keyword.insert(index,":*")
	        Home.fix_search(keyword)
	      end
	    end
	end
end
