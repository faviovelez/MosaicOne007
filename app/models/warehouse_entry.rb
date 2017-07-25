class WarehouseEntry < ActiveRecord::Base
  # Modelo que separa los costos de distintas entradas de material, para llevar un tracking de qué costo se debe tomar al dar de baja la mercancía
  belongs_to :product
  belongs_to :user
  belongs_to :movement
end
