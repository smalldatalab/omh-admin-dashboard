# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/path/to/my/cron_log.log"

every :day, :at => '12:20am' do
  command "find /home/mcarroll/admindashboard/current/data -type f -mtime +1 -exec rm {} +"
end

# Learn more: http://github.com/javan/whenever
