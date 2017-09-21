class MaterialsResistance < ActiveRecord::Base
  belongs_to :material
  belongs_to :resistance
end
