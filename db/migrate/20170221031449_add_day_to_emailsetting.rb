class AddDayToEmailsetting < ActiveRecord::Migration
  def change
  	add_column :emailsettings, :day, :string, :default=>"Monday"
  end
end
