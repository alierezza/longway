# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


begin
User.create!(:email=>"admin@longway.vn", :password=>"q1w2e3r4", :nama=>"LongWay Vietnam", :alamat=>"Vietnam", :telp=>"1324124", :role=>"Admin", :status=>true )


User.create!(:email=>"visualboard@longway.vn", :password=>"q1w2e3r4", :nama=>"LongWay Vietnam", :alamat=>"Vietnam", :telp=>"1324124", :role=>"Admin", :status=>true )

User.create!(:email=>"machineproblem@longway.vn", :password=>"q1w2e3r4", :nama=>"LongWay Vietnam", :alamat=>"Vietnam", :telp=>"1324124", :role=>"Admin", :status=>true )

rescue
	puts "user already exist"
end


ActiveRecord::Base.transaction do
  spreadsheet = Roo::Excelx.new("public/SMV.xlsx")
  header = spreadsheet.row(1)
  (6..spreadsheet.last_row).each do |i|

  	row = spreadsheet.row(i)
  	Article.create!(:session=>row[0] ,:name=>row[1],:duration=>row[2].round(2))

  end

  ["LINE", "OPR", "TARGET", "TARGET SUM", "ACT", "ACT SUM", "%", "PPH", "DEFECT", "RFT", "REMARK", "ARTICLE", "EFFICIENT"].each do |header|
  	HeaderBoard.create(name: header, name_vietnam: "")
  end
end