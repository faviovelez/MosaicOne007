namespace :stores do
  desc 'generate install code'

  task gen_install_code: :environment do |args|
    Store.where(install_code: nil).each do |store|
      store.save
    end
  end

end
