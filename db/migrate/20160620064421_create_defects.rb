class CreateDefects < ActiveRecord::Migration
  def change
    create_table :defects do |t|
      t.string :name
      t.string :defect_type
      t.text :description

      t.timestamps null: false
    end
  end
end
