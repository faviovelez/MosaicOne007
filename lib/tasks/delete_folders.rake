desc 'Delete bills folders'
task delete_bills_folders: :environment do
  `sudo rm -r /home/ubuntu/MosaicOne007/public/uploads/bill_files/*`
end
