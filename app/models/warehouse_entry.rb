class WarehouseEntry < ActiveRecord::Base
  # Modelo que separa los costos de distintas entradas de material, para llevar un tracking de qué costo se debe tomar al dar de baja la mercancía
  belongs_to :product
  belongs_to :user
  belongs_to :movement
  belongs_to :store

  before_save :check_products

  def check_products
    self.entry_number = WarehouseEntry.where(
      product_id: self.product.id).count
  end

  def fix_quantity
    self.quantity || 0
  end
end
