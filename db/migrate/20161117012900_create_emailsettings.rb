class CreateEmailsettings < ActiveRecord::Migration
  def change
    create_table :emailsettings do |t|
    	t.string	:email_time, :default=>"9:00 pm"
      t.timestamps null: false
    end
  end
end
