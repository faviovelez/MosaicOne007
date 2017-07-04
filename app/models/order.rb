class Order < ActiveRecord::Base
  belongs_to :user
  has_one :delivery_address
  has_one :additional_discount
  has_one :production
  belongs_to :request
  has_many :movements
end
