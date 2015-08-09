class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|

    	t.references	:user

    	t.string	:nama #nama mesin
    	t.integer	:no

    	
    	t.boolean	:status, :default=>true #status mesin rusak atau tidak
      t.timestamps null: false
    end
  end
end
