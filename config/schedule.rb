set :environment, 'production'
#set :output, "log/cron_log.log"

every 1.day, :at => "9:00 pm" do
  runner "Board.send_email", :output=>"log/send_email_log.log"
end

every '* 7,8,9,10,11,12,13,14,15,16 * * 1-6' do
  runner "Report.hourly", :output=>"log/report_hourly_log.log"
end

every :friday, :at => "11.00 pm" do
	runner "Board.remove", :output=>"log/remove_log.log"	
end

every :reboot do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  command "sleep 5 && ruby /var/www/longway/current/server.rb", :output=>"/var/www/longway/current/log/server.log"
end
