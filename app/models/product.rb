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

  validates :unique_code, uniqueness: { message: "El código de producto no se puede repetir, ya hay un producto con con este código."}

  def quantity
    inventory.try(:quantity) || 0
  end

  def movements_quantity
    pending_movements.sum(:quantity) || 0
  end

  def valid_inventory
    final_inventory = quantity - movements_quantity
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
