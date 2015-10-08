class AddMfgToDetailReports < ActiveRecord::Migration
  def change
  	add_column :detailreports, :mfg, :string
  end
end
