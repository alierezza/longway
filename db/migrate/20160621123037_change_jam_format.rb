class ChangeJamFormat < ActiveRecord::Migration
  def change
  	change_column(:detailreports, :jam, :string)
  end
end
