class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.string	:session
    	t.string	:name
    	t.float		:duration

      t.timestamps null: false
    end
  end
end
