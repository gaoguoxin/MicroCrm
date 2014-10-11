class NoticeWorker
  include Sidekiq::Worker

  def perform
    Course.each do |c|
      c.notice_at.split(',').each do |d|
        next if d.class != Fixnum
        mlist = c.orders.effective.map{|e| e.user.mobile}.flatten
        if c.start_date - d.day == Date.today
          SmsWorker.perform_async("lesson_pre_notice",mlist,{course_id:c.id.to_s})
        end
      end
    end
  end
end

Sidekiq::Cron::Job.create( name: 'Send pre lesson notice to student - every 1day at morning 6:00 ', cron: '0 6 * * *', klass: 'NoticeWorker')
