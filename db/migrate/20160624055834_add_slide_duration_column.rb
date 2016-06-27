class AddSlideDurationColumn < ActiveRecord::Migration
  def change
  	add_column :lines, :slide_duration, :integer, default: 15
  	add_column :images, :slide_duration, :integer, default: 15
  end
end
