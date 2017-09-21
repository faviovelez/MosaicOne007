class Resistance < ActiveRecord::Base
  has_many :materials, through: :materials_resistances
  has_many :materials_resistances
end
