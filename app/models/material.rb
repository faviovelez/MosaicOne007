class Material < ActiveRecord::Base
  has_many :resistances, through: :materials_resistances
  has_many :materials_resistances
  has_many :interior_colors
  has_many :exterior_colors
end
