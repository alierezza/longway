class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
    	t.boolean	:status, :default=>false
      t.timestamps null: false
    end
  end
end
