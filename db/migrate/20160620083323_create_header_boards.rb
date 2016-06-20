class CreateHeaderBoards < ActiveRecord::Migration
  def change
    create_table :header_boards do |t|
      t.string :name
      t.string :name_vietnam
      t.boolean :visible, default: true
      t.integer :order_no

      t.timestamps null: false
    end
  end
end
