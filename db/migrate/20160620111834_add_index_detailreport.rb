class AddIndexDetailreport < ActiveRecord::Migration
  def change
  	add_index :detailreports, [:report_id, :jam], unique: true
  end
end
