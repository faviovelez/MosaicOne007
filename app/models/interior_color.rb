class InteriorColor < ActiveRecord::Base
  has_many :materials, through: :materials_interior_colors
  has_many :materials_interior_colors
end
