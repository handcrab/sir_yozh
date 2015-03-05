# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end  
# set :environment, 'development'
set :output, "./log/cron.log" 
# whenever --set environment=development -i
 # chmod +rw cron.log 
# {
#   error:   "/log/error.log",
#  standard: "/log/cron.log"
# }
# whenever --set environment=development
every 2.minutes do
  puts 'QQQQQQQQQQQQQQQQQQQQQ!'
  runner "Channel.all.each(&:fetch)" #, environment: 'development'
end

