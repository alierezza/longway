class CreateDetailreportarticles < ActiveRecord::Migration
  def change
    create_table :detailreportarticles do |t|

    	t.references	:detailreport 
    	t.string		:article	#nama artikel
    	t.integer		:operator
    	t.integer		:output, :default=>0

      t.timestamps null: false
    end
  end
end
