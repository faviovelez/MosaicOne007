class ProspectSale < ActiveRecord::Base
  # Tabla que agrupa las ventas por cliente 'prospect' por mes (se usa para reportes)
  belongs_to :prospect
end
