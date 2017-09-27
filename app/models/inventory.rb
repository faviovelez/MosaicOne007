class Inventory < ActiveRecord::Base
  # Para controlar el stock de cada producto.
  belongs_to :product

  def set_quantity(num, operator = '+')
    self.quantity = self.fix_quantity.send(operator,num)
    self.save
  end

  def fix_quantity
    self.quantity || 0
  end
end
