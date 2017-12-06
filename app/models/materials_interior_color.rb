class MaterialsInteriorColor < ActiveRecord::Base
  belongs_to :material
  belongs_to :interior_color
end
