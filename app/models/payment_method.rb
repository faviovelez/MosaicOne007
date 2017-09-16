class PaymentMethod < ActiveRecord::Base
  has_many :bills
end
