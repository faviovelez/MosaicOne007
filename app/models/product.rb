class Product < ActiveRecord::Base
  # Catálogo de productos para todos los usuarios.
  has_many :images
  has_many :movements
  has_many :pending_movements
  has_one :inventory
  has_many :bill_receiveds
  has_many :products_bills
  has_many :bills, through: :products_bills
  has_many :product_requests
  has_many :product_sales
  belongs_to :business_unit
  has_many :production_requests
  has_one :request

  def quantity
    inventory.quantity || 0
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
end
