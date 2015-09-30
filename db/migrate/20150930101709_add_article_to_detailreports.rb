class AddArticleToDetailreports < ActiveRecord::Migration
  def change
  	add_column :detailreports, :article, :string
  end
end
