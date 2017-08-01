class Store < ActiveRecord::Base
  # Para crear o modificar nuevas tiendas.
  has_many :users
  has_many :requests
  has_many :prospects
  has_many :orders
  has_many :movements
  has_many :pending_movements
  belongs_to :delivery_address
  belongs_to :billing_address
  has_many :store_sales
  belongs_to :business_unit
  belongs_to :store_type

  validates :store_name, presence: { message: 'Debe especificar el nombre de la tienda.'}

  validates :store_code, presence: { message: 'Debe especificar un código para la tienda.'}

end
