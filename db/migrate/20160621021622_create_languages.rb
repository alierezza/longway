class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.text :message
      t.text :foreign_language

      t.timestamps null: false
    end
  end
end
