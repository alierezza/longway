class ChangeConstraint < ActiveRecord::Migration
  def change
  	change_column :detailreports, :country, :string, :null => true
  	change_column :detailreports, :category, :string, :null => true
  end
end
