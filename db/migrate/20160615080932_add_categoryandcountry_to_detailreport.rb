class AddCategoryandcountryToDetailreport < ActiveRecord::Migration
  def change
  	add_column :detailreports, :country, :string
  	add_column :detailreports, :category, :string
  end
end
