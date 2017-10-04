class CashRegister < ActiveRecord::Base
  belongs_to :store
  has_many :deposits
end
