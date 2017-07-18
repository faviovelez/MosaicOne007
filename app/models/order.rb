class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :delivery_address
  has_one :additional_discount
  has_one :production
  belongs_to :request
  has_many :movements
  has_many :pending_movements
  belongs_to :prospect
end
