class Store < ActiveRecord::Base
  # Para crear o modificar nuevas tiendas.
  has_many :users
  has_many :requests
  has_many :prospects
  has_many :orders
  has_many :movements
  has_many :pending_movements
  belongs_to :delivery_address
  has_many :store_sales
  belongs_to :business_unit
  belongs_to :business_group
  belongs_to :store_type
  has_many :warehouses
  belongs_to :cost_type
  has_many :suppliers
  has_many :bills
  has_many :discount_rules
  has_many :store_prospect, class_name: "Prospect", foreign_key: 'store_prospect_id'
  has_many :suppliers, through: :stores_suppliers
  has_many :stores_suppliers
  has_many :prospects
  has_many :products
  has_many :products, through: :stores_inventories
  has_many :stores_inventories
  has_many :products, through: :stores_warehouse_entries
  has_many :movements, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries

  validates :store_name, presence: { message: 'Debe especificar el nombre de la tienda.'}

  validates :store_code, presence: { message: 'Debe especificar un código para la tienda.'}

end
