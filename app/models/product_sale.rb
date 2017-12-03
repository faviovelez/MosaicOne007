class ProductSale < ActiveRecord::Base
  # Tabla resumen para reportes: agrupa las ventas por producto por mes (sirve para reportes)
  belongs_to :product
  belongs_to :store
  belongs_to :business_unit
end
