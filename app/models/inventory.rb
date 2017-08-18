class Inventory < ActiveRecord::Base
  # Para controlar el stock de cada producto.
  belongs_to :product

  def set_quantity(num)
    if quantity.present?
      self.quantity += num if self.quantity.present?
    end
    self.save
  end

  def fix_quantity
    self.quantity || 0
  end
end
