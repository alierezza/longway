if Emailsetting.count > 0

else
	email_time = Emailsetting.new
	email_time.save
end

%x[ whenever --clear-crontab ]
%x[ whenever --update-crontab ]