class Store < ActiveRecord::Base
  has_many :users
  has_many :requests
  has_many :prospects
  has_one :billing_address
  has_one :delivery_address
  delegate :
end
