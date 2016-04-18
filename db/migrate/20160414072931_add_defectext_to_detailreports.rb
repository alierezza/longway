class AddDefectextToDetailreports < ActiveRecord::Migration
  def change
  	add_column :detailreports, :defect_ext_bs3, :integer, :default=>0
  	add_column :detailreports, :defect_ext_bs7, :integer, :default=>0
  	add_column :detailreports, :defect_ext_bs13, :integer, :default=>0
  	add_column :detailreports, :defect_ext_bs15, :integer, :default=>0
  	add_column :detailreports, :defect_ext_bs17, :integer, :default=>0
  end
end
