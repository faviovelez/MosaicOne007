class DeliveryAddress < ActiveRecord::Base
  has_many :orders
  has_many :stores
  has_one :prospect
end
