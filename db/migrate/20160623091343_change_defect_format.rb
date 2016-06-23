class ChangeDefectFormat < ActiveRecord::Migration
  def change
  	change_column(:detailreports, :defect_int, :string, default: "{}")
  	change_column(:detailreports, :defect_ext, :string, default: "{}")
  end
end
