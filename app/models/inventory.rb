class Inventory < ActiveRecord::Base
  # Para controlar el stock de cada producto.
  belongs_to :product
end
