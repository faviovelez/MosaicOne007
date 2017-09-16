class PaymentCondition < ActiveRecord::Base
  has_many :bills
end
