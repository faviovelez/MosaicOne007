class Movement < ActiveRecord::Base
  # Para que sirva como un histórico de todos los movimientos de stock de product: bajas, altas, ventas, devoluciones, cancelaciones que afecten el modelo inventory.
  belongs_to :product
  belongs_to :order
  belongs_to :store
  belongs_to :supplier
  belongs_to :user
  belongs_to :business_unit
  belongs_to :prospect
  belongs_to :bill
  has_one :warehouse_entry
  has_many :delivery_attempts

#  after_save :new_movement, on: :create, if: :pending_quantity_greater_than_zero
#  after_save :sum_quantity, if: :type_is_alta
#  after_save :substract_quantity, if: :type_is_baja

#  def pending_movements_with_same_code
#    @prod_quantity = 0
#    PendingMovement.each do |mov|
#      if product >= mov.product
#        @prod_quantity = mov.quantity
#      end
#    end
#    @prod_quantity
#  end

#  def pending_quantity_greater_than_zero
#    pending_movements_with_same_code
#    @prod_quantity > 0
#  end

#  def new_movement
#    m = Movement.create(quantity: @prod_quantity, movement_type: 'baja', product: product)
#    erase_pending_movement
#  end

#  def erase_pending_movement
#    pm = PendingMovement.find_by_product_id(product)
#    pm.destroy
#  end

#  def type_is_alta
#    movement_type == 'alta'
#  end

#  def type_is_baja
#    movement_type == 'baja'
#  end

#  def sum_quantity
    # Utilizar warehouse_entry e Inventory para esto, en lugar de solo inventory
#    q = Inventory.find_by_product_id(product).quantity.to_i
#    q += quantity
#    q.save
#  end

#  def substract_quantity
    # Utilizar wharehouse_entry e inventory para esto, en lugar de solo inventory
#    q = Inventory.find_by_product_id(product).quantity.to_i
#    q -= quantity
#    q.save
#  end

end
