class AddPoToDetailReports < ActiveRecord::Migration
  def change
  	add_column :detailreports, :po, :string
  end
end
