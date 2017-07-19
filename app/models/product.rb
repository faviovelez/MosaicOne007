class Product < ActiveRecord::Base
  # Catálogo de productos para todos los usuarios.
  has_many :images
  has_many :movements
  has_one :inventory
end
