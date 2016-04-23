class AddIndexReport < ActiveRecord::Migration
  def change
  	add_index :reports, [:line_id, :tanggal], unique: true
  end
end
