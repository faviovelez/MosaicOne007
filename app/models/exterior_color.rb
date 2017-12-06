class ExteriorColor < ActiveRecord::Base
  has_many :materials, through: :materials_exterior_colors
  has_many :materials_exterior_colors
end
