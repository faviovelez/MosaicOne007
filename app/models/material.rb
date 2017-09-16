class Material < ActiveRecord::Base
  has_many :resistances
  has_many :interior_colors
  has_many :exterior_colors
end
