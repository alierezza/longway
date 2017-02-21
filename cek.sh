#!/bin/bash
service=server.rb
NOW=$(date '+%d/%m/%Y %H:%M:%S');

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo "$NOW -  $service is running!!!"
else
ruby /var/www/longway/current/server.rb
echo "$NOW - start server.rb"
fi

delayedjob=delayed_job

if (( $(ps -ef | grep -v grep | grep $delayedjob | wc -l) > 0 ))
then
echo "$NOW -  $delayedjob is running!!!"
else
cd /var/www/longway/current/ && RAILS_ENV=production bin/delayed_job restart
echo "$NOW - start delayed_job"
fi