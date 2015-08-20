
set :output, "log/cron_log.log"

every 1.day, :at => "6 pm" do
  runner "Board.send_email"
end

every '0 7,8,9,10,11,12,13,14,15,16,17,18 * * *' do
  runner "Report.hourly"
end

#@reboot sleep 5 && 'ruby /home/gloobalway/public_html/server.rb >> log/server.log 2>&1'