class Warehouse < ActiveRecord::Base
  belongs_to :delivery_address
  belongs_to :business_unit
end
