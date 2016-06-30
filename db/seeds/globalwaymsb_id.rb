# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


begin
User.create!(:email=>"admin@globalwayindonesia.com", :password=>"q1w2e3r4", :nama=>"Global Way International", :alamat=>"Sidoarjo", :telp=>"1324124", :role=>"Admin", :status=>true )


User.create!(:email=>"visualboard@globalwayindonesia.com", :password=>"q1w2e3r4", :nama=>"Global Way International", :alamat=>"Sidoarjo", :telp=>"1324124", :role=>"Admin", :status=>true )

User.create!(:email=>"machineproblem@globalwayindonesia.com", :password=>"q1w2e3r4", :nama=>"Global Way International", :alamat=>"Sidoarjo", :telp=>"1324124", :role=>"Admin", :status=>true )

rescue
  puts "user already exist"
end


ActiveRecord::Base.transaction do
  # spreadsheet = Roo::Excelx.new("public/SMV.xlsx")
  # header = spreadsheet.row(1)
  # (6..spreadsheet.last_row).each do |i|

  # 	row = spreadsheet.row(i)
  # 	Article.create(:session=>row[0] ,:name=>row[1],:duration=>row[2].round(2))

  # end

  ["LINE", "OPR", "TRGT", "TRGT SUM", "ACT", "ACT SUM", "%", "PPH", "DEFECT", "RFT", "REMARK", "ARTICLE", "EFFICIENT"].each do |header|
  	HeaderBoard.create(name: header, name_vietnam: "")
  end

  ["Monday", "Tuesday", "Wednesday", "Thursday", "Saturday"].each do |day|
    working_day = WorkingDay.create(name: day)
    if working_day.id != nil
      [["07:00", "08:00"], ["08:00", "09:00"], ["09:00", "10:00"], ["10:00", "11:00"],
      ["11:00", "12:00"], ["13:00", "14:00"], ["14:00", "15:00"], ["15:00", "16:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Work")
      end
      [["12:00", "13:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Break")
      end
      [["16:00","17:00"],["17:00", "18:00"], ["18:00", "19:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Overtime")
      end
    end
  end

  ["Friday"].each do |day|
    working_day = WorkingDay.create(name: day)
    if working_day.id != nil
      [["07:00", "08:00"], ["08:00", "09:00"], ["09:00", "10:00"], ["10:00", "11:00"],
      ["11:00", "11:30"], ["13:00", "14:00"], ["14:00", "15:00"], ["15:00", "16:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Work")
      end
      [["11:30", "12:00"],["12:00","13:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Break")
      end
      [["16:00","17:00"],["17:00", "18:00"], ["18:00", "19:00"]].each do |hour|
        working_day.working_hours.create(start: hour[0], end: hour[1], working_state: "Overtime")
      end
    end
  end


  WorkingDay.create(name: "Sunday")

  [["11A", "JAHIT TANGAN BURUK/ULANGI DIJAHIT"], ["11B", "KERUT/JAHITAN ROBEK"], ["11C", "JAHITAN LONGGAR"],
  ["11J", "PELOMPAT/TAK TERJAHIT"], ["11L", "TAK TEPAT POSISI/DISLOKASI"], ["13D", "LUBANG KATUB DEFECT/MASALAH"]].each do |defect|
     Defect.create(name: defect[0], defect_type: "Internal", description: defect[1])
  end

  [["BS2", "SABLON POLA TAK PENUH"], ["BS3", "SABLON TERKENA HAMBATAN BENDA"], ["BS7", "BAYANGAN GANDA"],
  ["BS13", "TAK TEPAT POSISI/TIDAK AKURAT/MIRING"], ["BS15", "KONTAMINASI TINTA"], ["BS17", "SABLON FARIASI BEDA WARNA"]].each do |defect|
    Defect.create(name: defect[0], defect_type: "External", description: defect[1])
  end

  Language.create(:message=>"Logout",:description=>"Showing on Tablet",:foreign_language=>"Logout")
  Language.create(:message=>"Dont Forget To Logout Before Leaving",:description=>"Showing on Tablet",:foreign_language=>"<font size=4>Jangan lupa <b><font color=red>log out</font></b> kalau sudah tidak digunakan lagi</font>")
  Language.create(:message=>"Enter Correct Article Code",:description=>"Showing on Tablet",:foreign_language=>"<font color=red><b>Masukan Code Article dengan benar</b></font>")
  Language.create(:message=>"Company Title",:description=>"Showing on Visual Board, excel, etc", :foreign_language=>"GLOBALWAY - MSB")
  Language.create(:message=>"Machine Problem",:description=>"Showing on Tablet", :foreign_language=>"Machine Problem")

  Setting.create(name: "Country")
  Setting.create(name: "Category")


end



