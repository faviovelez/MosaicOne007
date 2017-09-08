class PendingMovement < ActiveRecord::Base
  # Movimientos temporales que se borran una vez que se cree un movimiento y sea afectada la cantidad en inventory.
  belongs_to :product
  belongs_to :order
  belongs_to :store
  belongs_to :supplier
  belongs_to :user
  belongs_to :business_unit
  belongs_to :prospect
  belongs_to :bill
  has_many :product_requests
end
