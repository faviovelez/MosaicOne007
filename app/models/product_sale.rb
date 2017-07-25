class ProductSale < ActiveRecord::Base
  # Tabla resumen para reportes: agrupa las ventas por producto por mes (sirve para reportes)
  belongs_to :product
end
