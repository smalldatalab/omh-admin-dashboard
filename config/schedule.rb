set :output, "log/cron_job.log"

every '0,5,10,15,20,25,30,35,40,45,50,55 * * * *' do
  command "echo 'two'"
end

every :day, :at => '12:20am' do
  command "find " +  Whenever.path + "/data -type f -mtime +1 -exec rm {} +"
end
