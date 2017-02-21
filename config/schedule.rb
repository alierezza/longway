require File.expand_path('../environment', __FILE__)


set :environment, Rails.env
#set :output, "log/cron_log.log"

every 1.day, :at => Emailsetting.first.try(:email_time) || "21:00" do
  runner "Board.send_email", :output=>"log/send_email_log.log"
end

every '* 7,8,9,10,11,12,13,14,15,16,17,18,19 * * 1-6' do
  runner "Report.hourly", :output=>"log/report_hourly_log.log"
end

every :sunday, :at => "11.00 am" do
	runner "Board.remove", :output=>"log/remove_log.log"	
end

every :reboot do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  command "sleep 5 && ruby /var/www/longway/current/server.rb", :output=>"/var/www/longway/current/log/server.log"
  command "sleep 10 && cd /var/www/longway/current/ && RAILS_ENV=#{Rails.env} bin/delayed_job restart"
end

every 1.minute do
	command "/var/www/longway/cek.sh", :output=>"log/cek_soket_and_delayedjob_running.log"
end
