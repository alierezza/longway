class ChangeDefectFormat2 < ActiveRecord::Migration
  def change
    change_column(:detailreports, :defect_int, :text, default: "{}")
    change_column(:detailreports, :defect_ext, :text, default: "{}")
  end
end
