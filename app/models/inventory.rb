class Inventory < ActiveRecord::Base
  # Para controlar el stock de cada producto.
  belongs_to :product

  def set_quantity(num)
    self.quantity += num if self.quantity.present?
    self.save
  end
end
