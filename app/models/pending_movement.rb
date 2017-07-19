class PendingMovement < ActiveRecord::Base
  # Movimientos temporales que se borran una vez que se cree un movimiento y sea afectada la cantidad en inventory.
  belongs_to :product
  belongs_to :order
end
