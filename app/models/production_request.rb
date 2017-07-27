class ProductionRequest < ActiveRecord::Base
  belongs_to :product
  belongs_to :production_order
end
