class StoresWarehouseEntry < ActiveRecord::Base
  belongs_to :product
  belongs_to :store
  belongs_to :movement
end
