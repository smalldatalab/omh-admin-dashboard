set :output, Whenever.path + "/log/cron_job.log"

every :day, :at => '12:20am' do
  command "find " +  Whenever.path + "/data -type f -mtime +1 -exec rm {} +"
end
