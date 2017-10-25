class Movement < ActiveRecord::Base
  # Para que sirva como un histórico de todos los movimientos de stock de product: bajas, altas, ventas, devoluciones, cancelaciones que afecten el modelo inventory.
  belongs_to :product
  belongs_to :order
  belongs_to :store
  belongs_to :supplier
  # Ya que se modifique, quitaré la línea de movements
  belongs_to :user
  belongs_to :business_unit
  belongs_to :prospect
  belongs_to :bill
  has_one :warehouse_entry
  has_many :delivery_attempts
  belongs_to :product_request
  belongs_to :discount_rule
  belongs_to :seller_user, class_name: 'User'
  belongs_to :buyer_user, class_name: 'User'
  has_many :stores, through: :stores_warehouse_entries
  has_many :products, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries
  belongs_to :ticket

  before_save :create_update_summary, if: :is_sales?

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
      prospect_id: prospect.id,
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
      prospect_id: prospect.id
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

  def get_product
    self.product || self.product_request.product
  end

  def split(quantity, cost)
    movement = remove_attributes(self.attributes)
    movement = Movement.create(movement)
    movement.update_attributes(
      quantity: quantity,
      cost:     cost
    )
    movement
  end

  def remove_attributes(attributes)
    %w(id created_at updated_at).each do |attr|
      attributes.delete(attr)
    end
    attributes
  end

  def process_inventories(hash, pending)
    if hash[:actual] < pending
      to_used = hash[:actual] - pending
      hash[:to_processed] -= to_used.abs
    end
  end

  def transform(pending, inventory)
    if inventory.quantity > pending.quantity
      movement = Movement.create(
        remove_attributes(pending.attributes)
      )
      if movement.save
        inventory.set_quantity(pending.quantity, '-')
        movement.product_request.update(
          status: 'asignado'
        )
        return true
      end
    end
    false
  end

  def actual_inventory
    get_product.inventory.quantity || 0
  end

  def related_warehouses(order_type)
    WarehouseEntry.where(
      product: self.get_product
    ).order(
      "created_at #{order_type}"
    )
  end

  def convert_warehouses(order_type, local_quantity)
    related_warehouses(order_type).each do |entry|
      if local_quantity > entry.fix_quantity
        local_quantity -= entry.fix_quantity
        entry.destroy
      else
        entry.update(
          quantity: entry.quantity - local_quantity
        )
      end
    end
  end

  def process_pendings(order_type, quantity)
    inventories = {
      actual:       actual_inventory - quantity,
      to_processed: quantity
    }
    inventory = get_product.inventory
    PendingMovement.where(
      product: self.get_product
    ).order(
      "created_at #{order_type}"
    ).each do |pending|
      if transform(pending, inventory)
        convert_warehouses(order_type, pending.quantity)
        pending.destroy
        process_inventories(inventories, pending.quantity)
        inventories[:actual] = actual_inventory
      end
    end
    inventories[:to_processed]
  end

  def process_extras(order_type, total_quantity, order)
    self.update(order: order)
    is_end = false
    related_warehouses(order_type).each do |entry|
      if total_quantity >= entry.fix_quantity
        split(
          entry.fix_quantity,
          entry.movement.fix_cost * entry.fix_quantity
        )
        total_quantity -= Movement.last.fix_quantity
        temp_quantity = Movement.last.fix_quantity
        entry.destroy
      else
        self.update(quantity: total_quantity)
        temp_quantity = total_quantity
        entry.update(
          quantity: (entry.fix_quantity - total_quantity)
        )
        is_end = true
      end
      get_product.update_inventory_quantity(
        temp_quantity
      )
      break if is_end
    end
  rescue
    return false
  end

  class << self

    def initialize_with(object, user ,type)
      product = object.product
      store   = user.store
      prospect = Prospect.find_by_store_prospect_id(store)
      create(
        product: product,
        unique_code: product.unique_code,
        store: store,
        initial_price: product.price,
        movement_type: type,
        user: user,
        business_unit: store.business_unit,
        prospect: prospect
      )
    end

  end
end
