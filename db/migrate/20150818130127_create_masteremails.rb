class CreateMasteremails < ActiveRecord::Migration
  def change
    create_table :masteremails do |t|
    	t.string	:name
      t.timestamps null: false
    end
  end
end
