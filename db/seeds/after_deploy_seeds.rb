if Emailsetting.count > 0

else
	email_time = Emailsetting.new
	email_time.save
end


%x[ whenever --set 'environment=production&path=/var/www/longway/current/config/schedule.rb' --update-crontab ]