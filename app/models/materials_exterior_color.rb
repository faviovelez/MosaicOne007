class MaterialsExteriorColor < ActiveRecord::Base
  belongs_to :material
  belongs_to :exterior_color
end
