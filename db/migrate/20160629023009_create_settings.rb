class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.boolean :visible, default: false

      t.timestamps null: false
    end
  end
end
