class Order < ActiveRecord::Base
  # Agrupa todos los movements en un solo pedido.
  belongs_to :user
  belongs_to :delivery_address
  has_one :additional_discount
  has_one :production
  belongs_to :request
  has_many :movements
  has_many :pending_movements
  belongs_to :prospect
end
