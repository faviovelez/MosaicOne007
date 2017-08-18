class Order < ActiveRecord::Base
  # Agrupa todos los movements y 'product_requests' (son para producto de línea, no confundir con 'requests' que son cotizaciones de productos especiales) en un solo pedido 'Order'.
  belongs_to :user
  belongs_to :delivery_address
  belongs_to :request
  has_many :movements
  has_many :product_requests
  has_many :pending_movements
  belongs_to :prospect
  has_many :bills
  belongs_to :carrier
  has_many :delivery_packages
  belongs_to :store

  def all_movements
    self.movements + self.pending_movements
  end

end
