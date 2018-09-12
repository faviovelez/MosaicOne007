class ListPriceChange < ActiveRecord::Base
  belongs_to :user
  mount_uploader :document_list, PriceListUploader
end
