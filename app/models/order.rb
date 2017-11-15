class Order < ActiveRecord::Base
  # Agrupa todos los movements y 'product_requests' (son para producto de línea, no confundir con 'requests' que son cotizaciones de productos especiales) en un solo pedido 'Order'.
  has_many :users, through: :orders_users
  has_many :orders_users
  belongs_to :delivery_address
  belongs_to :request
  has_many :movements
  has_many :product_requests
  has_many :pending_movements
  belongs_to :prospect
  belongs_to :bill
  belongs_to :carrier
  has_many :delivery_packages
  belongs_to :store
  has_many :design_requests
  belongs_to :delivery_attempt
  has_many :payments

  def all_movements
    self.movements + self.pending_movements
  end

end
