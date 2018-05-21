# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

env :PATH, ENV['PATH']

every :day, at: '07:30am' do
 rake 'send_collection_email'
end

# Learn more: http://github.com/javan/whenever
