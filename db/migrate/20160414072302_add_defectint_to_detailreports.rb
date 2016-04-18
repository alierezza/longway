class AddDefectintToDetailreports < ActiveRecord::Migration
  def change
  	add_column :detailreports, :defect_int_11b, :integer, :default=>0
  	add_column :detailreports, :defect_int_11c, :integer, :default=>0
  	add_column :detailreports, :defect_int_11j, :integer, :default=>0
  	add_column :detailreports, :defect_int_11l, :integer, :default=>0
  	add_column :detailreports, :defect_int_13d, :integer, :default=>0
  end
end
