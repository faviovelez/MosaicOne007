class Product < ActiveRecord::Base
  # Catálogo de productos para todos los usuarios.
  has_many :images, dependent: :destroy
  has_many :movements, dependent: :destroy
  has_many :pending_movements, dependent: :destroy
  has_one :inventory, dependent: :destroy
  has_many :bill_receiveds, dependent: :destroy
  has_many :products_bills, dependent: :destroy
  has_many :bills, through: :products_bills, dependent: :destroy
  has_many :product_requests, dependent: :destroy
  has_many :product_sales, dependent: :destroy
  belongs_to :business_unit
  has_many :production_requests, dependent: :destroy
  has_one :request, dependent: :destroy
  belongs_to :warehouse
  belongs_to :unit
  belongs_to :sat_key
  belongs_to :sat_unit_key
  belongs_to :supplier
  belongs_to :store
  has_many :stores, through: :stores_inventories
  has_many :stores_inventories
  has_many :stores, through: :stores_warehouse_entries
  has_many :movements, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries

  validates :unique_code, presence: { message: "Debe anotar un código de producto."}

  validates :price, presence: { message: "Es necesario el precio del producto."}

  validates :unique_code, uniqueness: { message: "El código de producto no se puede repetir, ya hay un producto con con este código."}

  def update_inventory_quantity(quantity)
    actual_quantity = self.inventory.quantity
    self.inventory.update(
      quantity: actual_quantity - quantity
    )
  end

  def quantity
    inventory.try(:quantity) || 0
  end

  def movements_quantity
    pending_movements.sum(:quantity) || 0
  end

  def valid_inventory
    final_inventory = quantity
    if final_inventory < 0
      return 0
    end
    final_inventory
  end

  class << self
    def has_inventory
      all.select {|product| product.inventory }
    end
  end
end
