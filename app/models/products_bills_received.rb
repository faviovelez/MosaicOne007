class ProductsBillsReceived < ActiveRecord::Base
  belongs_to :bill_received
  belongs_to :product
end
