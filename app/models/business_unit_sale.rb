class BusinessUnitSale < ActiveRecord::Base
  # Tabla resumen de ventas por unidad de negocio (agrupa varias 'stores').
  belongs_to :business_unit
end
