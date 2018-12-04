desc 'Delete bills folders'
task delete_bills_folders: :environment do
  @base = Rails.root.join('public', 'uploads')

  `rm -r "#{@base}"/bill_files/*`
end
