class ImpressionType < ActiveRecord::Base
  has_many :materials, through: :materials_impression_types
  has_many :materials_impression_types
end
