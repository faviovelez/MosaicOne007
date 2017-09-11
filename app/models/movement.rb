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
  has_many :product_requests

  before_save :create_update_summary, if: :is_sales?

  def update_inventory
    product = self.product
    product_inventory = product.inventory
    product_inventory.update(
      quantity: product_inventory.quantity - self.quantity
    )
    binding.pry
  end

  def create_update_summary
    if dont_exist_record_month
      create_new_summary
    else
      update_summary
    end
  end

  def dont_exist_record_month
    !!(ProspectSale.where(month: Date.today.month).first.nil?)
  end

  def update_summary
    update_reports_data(
      ProspectSale.find_by_month(Date.today.month)
    ).update(
      prospect_id: store.id,
    )
    update_reports_data(
      ProductSale.find_by_month(Date.today.month)
    )
    .update(
      product_id: product.id,
    )
    update_reports_data(
      BusinessUnitSale.find_by_month(Date.today.month)
    ).update(
      business_unit_id: business_unit.id
    )
    update_reports_data(
      BusinessGroupSale.find_by_month(Date.today.month)
    ).update(
      business_group_id: business_unit.business_group_id,
    )
  end

  def create_new_summary
    create_reports_data(
      ProspectSale
    ).update(
      prospect_id: store.id
    )
    create_reports_data(
      ProductSale)
    .update(
      product_id: product.id,
    )
    create_reports_data(
      BusinessUnitSale
    ).update(
      business_unit_id: business_unit.id
    )
    create_reports_data(
      BusinessGroupSale
    ).update(
      business_group_id: business_unit.business_group_id,
    )
  end

  def update_reports_data(object)
    sales_amount = fix_quantity * fix_final_price
    sales_quantity = fix_quantity
    cost = fix_cost * fix_quantity
    month = Date.today.month
    year  = Date.today.year
    object.update_attributes(
      sales_amount: sales_amount,
      sales_quantity: sales_quantity,
      cost: cost,
      month: month,
      year: year
    )
    object
  end

  def create_reports_data(type)
    sales_amount = fix_quantity * fix_final_price
    sales_quantity = fix_quantity
    cost = fix_cost * fix_quantity
    month = Date.today.month
    year  = Date.today.year
    type.create(
      sales_amount: sales_amount,
      sales_quantity: sales_quantity,
      cost: cost,
      month: month,
      year: year
    )
  end

  def business_unit
     BusinessUnit.find(
       self.store.business_unit_id
     )
  end

  def is_sales?
    !!(movement_type == 'venta')
  end

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

  def fix_cost
    self.cost || 0
  end

  def fix_quantity
    self.quantity || 0
  end

  def fix_initial_price
    initial_price || 0
  end

  def fix_final_price
    self.cost || 0
  end
end
