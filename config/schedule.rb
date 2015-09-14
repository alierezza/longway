
set :output, "log/cron_log.log"

every 1.day, :at => "6:10 pm" do
  runner "Board.send_email"
end

every '* 8,9,10,11,12,13,14,15 * * 1-5' do
  runner "Report.hourly"
end

# every :friday, :at => "11.00 pm" do
# 	runner "Board.remove"	
# end

#@reboot sleep 5 && 'ruby /home/gloobalway/public_html/server.rb >> log/server.log 2>&1'