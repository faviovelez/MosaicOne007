class Store < ActiveRecord::Base
  has_many :users
  has_many :requests
  has_many :prospects
  belongs_to :delivery_address
  belongs_to :billing_address
end
