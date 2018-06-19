class Order < ActiveRecord::Base
  # Agrupa todos los movements y 'product_requests' (son para producto de línea, no confundir con 'requests' que son cotizaciones de productos especiales) en un solo pedido 'Order'.
  belongs_to :delivery_address
  belongs_to :request
  belongs_to :prospect
  belongs_to :bill
  belongs_to :carrier
  belongs_to :order
  belongs_to :store
  belongs_to :request_user, class_name: 'User'
  belongs_to :confirm_user, class_name: 'User'
  belongs_to :corporate, class_name: 'Store'
  has_many :users, through: :orders_users
  has_many :orders_users
  has_many :movements
  has_many :product_requests
  has_many :pending_movements
  has_many :delivery_packages
  has_many :design_requests
  has_one :delivery_attempt
  has_many :payments
  has_many :date_advises
  has_many :service_offereds

  def all_movements
    self.movements + self.pending_movements
  end

  def month_year
    self.created_at.strftime('%m / %Y')
  end

end
