class CreateWorkingHours < ActiveRecord::Migration
  def change
    create_table :working_hours do |t|
      t.references :working_day, index: true, foreign_key: true
      t.string :start
      t.string :end
      t.string :working_state

      t.timestamps null: false
    end
  end
end
