class StoreSale < ActiveRecord::Base
  # Tabla para agrupar las ventas por tienda por mes (sirve para reportes)
  belongs_to :store
end
