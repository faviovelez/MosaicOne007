desc 'Send collection email'
task send_collection_email: :environment do
  today_beginning = Date.today.beginning_of_day
  today_end = Date.today.end_of_day
  today = Date.today.to_date
  on_date_advise = DateAdvise.where(date: today_beginning..today_end)
  before_date_advise = DateAdvise.where(before_date: today_beginning..today_end)
  after_date_advise = DateAdvise.where(after_date: today_beginning..today_end)
  advises = [before_date_advise, on_date_advise, after_date_advise]
  advises.each do |array|
    if array != []
      array.each do |item|
        if item.store.collection_active && (item.prospect == nil || (item.prospect != nil && item.prospect.collection_active))
          CollectionMailer.send_collection_before_mail(item).deliver_now if item.before_date.to_date == today
          CollectionMailer.send_collection_mail(item).deliver_now if item.date.end_of_day.to_date == today
          CollectionMailer.send_collection_after_mail(item).deliver_now if item.after_date.to_date == today
        end
      end
    end
  end
end
