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
  	Article.create(:session=>row[0] ,:name=>row[1],:duration=>row[2].round(2))

  end

  ["LINE", "OPR", "TARGET", "TARGET SUM", "ACT", "ACT SUM", "%", "PPH", "DEFECT", "RFT", "REMARK", "ARTICLE", "EFFICIENT"].each do |header|
  	HeaderBoard.create(name: header, name_vietnam: "")
  end

  ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].each do |day|
    working_day = WorkingDay.create(name: day)
    [["07:30", "08:30"], ["08:30", "09:30"], ["09:30", "10:30"], ["10:30", "11:30"],
    ["12:30", "13:30"], ["13:30", "14:30"], ["14:30", "15:30"], ["15:30", "16:30"]].each do |hour|
      working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Work")
    end
    [["11:30", "12:30"], ["16:30", "17:00"]].each do |hour|
      working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Break")
    end
    [["17:00", "18:00"], ["18:00", "19:00"], ["19:00", "20:00"]].each do |hour|
      working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Overtime")
    end
  end
end

Language.create(:message=>"Logout",:description=>"Showing on Tablet",:foreign_language=>"Logout")
Language.create(:message=>"Dont Forget To Logout Before Leaving",:description=>"Showing on Tablet",:foreign_language=>"<font size=4>Dont Forget to <b><font color=red>log out</font></b> Before you are leaving</font>")
Language.create(:message=>"Enter Correct Article Code",:description=>"Showing on Tablet",:foreign_language=>"<font color=red><b>Enter Correct Article Code</b></font>")
Language.create(:message=>"Company Title",:description=>"Showing on Visual Board, excel, etc", :foreign_language=>"LONGWAY VIETNAM")


