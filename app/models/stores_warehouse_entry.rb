class StoresWarehouseEntry < ActiveRecord::Base
  belongs_to :product
  belongs_to :store
  belongs_to :movement
  belongs_to :store_movement
end
