class AddJamendToDetailreport < ActiveRecord::Migration
  def change
  	add_column :detailreports, :jam_end, :string
  end
end
