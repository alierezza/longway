class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_one :line

  def self.find_first_by_auth_conditions(warden_conditions)

    conditions = warden_conditions.dup

    user = User.find_by(:email=>conditions[:email])

    if user != nil
    	if user.status == true
    		user
    	else
    		nil
    	end
    else
    	nil
    end
  end
end
