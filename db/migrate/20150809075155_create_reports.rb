class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|

    	t.references	:line

    	t.date	:tanggal

      t.timestamps null: false
    end
  end
end
