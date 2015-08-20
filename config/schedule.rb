# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/log/cron_log.log"

every 1.day, :at => "6 pm" do
  runner "Board.send_email"
end

every '0 7,8,9,10,11,12,13,14,15,16,17,18 * * *' do
  runner "Report.hourly"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
