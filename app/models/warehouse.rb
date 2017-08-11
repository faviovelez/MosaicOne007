class Warehouse < ActiveRecord::Base
  belongs_to :delivery_address
  belongs_to :business_unit
  belongs_to :store
end
