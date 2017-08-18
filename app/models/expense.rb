class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_unit
  belongs_to :user
  belongs_to :bill_received
end
