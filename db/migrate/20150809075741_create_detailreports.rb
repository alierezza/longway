class CreateDetailreports < ActiveRecord::Migration
  def change
    create_table :detailreports do |t|

      t.timestamps null: false
    end
  end
end
