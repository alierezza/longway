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