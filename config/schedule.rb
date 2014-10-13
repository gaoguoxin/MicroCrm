# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :output, {
    :error    => "#{path}/log/error.log",
    :standard => "#{path}/log/cron.log"
}

case @environment
when 'production'
	every 5.minutes do 
		runner "Course.batch_update_status"
	end
	every 1.day, :at => '6:00 am' do
	  runner "Course.send_pre_notice"
	end

when 'development'
	every 5.minutes do 
		runner "Course.batch_update_status"
	end
end
