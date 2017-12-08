class MaterialsImpressionType < ActiveRecord::Base
  belongs_to :material
  belongs_to :impression_type
end
