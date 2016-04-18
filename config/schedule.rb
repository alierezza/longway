
set :output, "log/cron_log.log"

every 1.day, :at => "6:10 pm" do
  runner "Board.send_email"
end

every '* 7,8,9,10,11,12,13,14,15,16,17,18 * * 1-6' do
  runner "Report.hourly"
end

every :friday, :at => "11.00 pm" do
	runner "Board.remove"	
end

every :reboot do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "sleep 5 && 'ruby /home/gloobalway/public_html/server.rb >> log/server.log 2>&1'"
end
