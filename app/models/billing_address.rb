class BillingAddress < ActiveRecord::Base
  has_many :stores
  has_many :prospects
end
