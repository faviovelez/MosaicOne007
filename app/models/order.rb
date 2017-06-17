class Order < ActiveRecord::Base
  belongs_to :user
  has_one :delivery_address
  has_one :additional_discount
  has_one :production
  has_one :product_catalog
  belongs_to :request
end
