class AddVisibleToLines < ActiveRecord::Migration
  def change
  	add_column :lines, :visible, :boolean, :default => true #terlihat atau tidak
  end
end
