require_relative './config/boot'
require_relative './config/environment'
# require_relative './boot'
# require_relative './environment'

require 'clockwork'
include Clockwork

# every(1.day, 'user.pages.update', at: '12:00'){ User.unblocked.all.each(&:update_pages_info!) }
# every(1.day, 'pages.refresh_likes_count', at: '23:00'){ Facebook::Page.update_likes_count! }
# every(1.day, 'reminders.send', :at => '01:30') { Reminder.send_later(:send_reminders) }
# every(6.hours, 'user.apps.persistence.check'){ Delayed::Job.enqueue UpdateApplicationPersistenceJob.new }
# every(1.hour, 'feeds.refresh') { Feed.send_later(:refresh) }

# module Clockwork
#   handler do |job, time|
#     puts "Running #{job}, at #{time}"
#   end

#   every(10.seconds, 'frequent.job')
#   every(2.minutes, 'less.frequent.job')
#   every(1.hour, 'hourly.job')

#   every(1.day, 'midnight.job', :at => '00:00')
# end

every(2.hours, 'Fetch all posts') { Channel.delay.fetch_all_posts }
