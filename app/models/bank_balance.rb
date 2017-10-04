class BankBalance < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_unit
end
