class PaymentForm < ActiveRecord::Base
  has_many :bills
end
