class BillSale < ActiveRecord::Base
  belongs_to :business_unit
  belongs_to :store
end
