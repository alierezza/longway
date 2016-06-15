class AddCategoryandcountryToDetailreport < ActiveRecord::Migration
  def change
  	add_column :detailreports, :country, :string, null: false
  	add_column :detailreports, :category, :string, null: false
  end
end
