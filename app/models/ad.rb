class Ad < ActiveRecord::Base
	
	validate :there_can_only_be_one


private
	def there_can_only_be_one
    	errors.add_to_base('There can only be one') if Ad.count > 1
  	end
end
