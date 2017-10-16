class PaymentForm < ActiveRecord::Base
  has_many :bills
  has_many :payments
end
