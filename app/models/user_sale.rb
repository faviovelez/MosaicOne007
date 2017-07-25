class UserSale < ActiveRecord::Base
  # Tabla que agrupa todas las ventas por usuario (sirve para reportes de pago de comisiones por persona)
  belongs_to :user
end
