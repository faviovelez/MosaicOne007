class TaxRegime < ActiveRecord::Base
  has_many :bills
  has_many :billing_addresses
end
