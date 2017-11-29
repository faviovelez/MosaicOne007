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
  belongs_to :seller_user, class_name: 'User', foreign_key: 'seller_user_id'
  belongs_to :buyer_user, class_name: 'User', foreign_key: 'buyer_user_id'
  has_many :stores, through: :stores_warehouse_entries
  has_many :products, through: :stores_warehouse_entries
  has_many :stores_warehouse_entries
  belongs_to :ticket
  belongs_to :tax
  has_many :sales, through: :sales_movements, foreign_key: 'sales_id'
  has_many :sales_movements
  belongs_to :entry_movement, class_name: 'Movement', foreign_key: 'entry_movement_id'

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
      cost: cost,
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

  def transform(pending, inventory, mov)
    if inventory.quantity >= pending.quantity
      movement = Movement.create(
        remove_attributes(pending.attributes)
      )
      if movement.save
        movement.update(cost: mov.product.cost, total_cost: mov.product.cost * movement.quantity, entry_movement: mov)
        inventory.set_quantity(pending.quantity, '-')
        movement.product_request.update(
          status: 'asignado'
        )
        status_arr = []
        order = movement.order
        order.product_requests.each do |pr|
          status_arr << pr.status
        end
        if status_arr.uniq.length == 1 && status_arr.first == 'asignado'
          order.update(status:'mercancía asignada')
        end
        #Revisar con qué atributos está creándose (precio y costo)
        # y si se va a respetar precio de cuando se creó el pending_movement
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
    @movement = []
    related_warehouses(order_type).each do |entry|
      @movement << entry.movement unless @movement.include?(entry.movement)
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

  def process_pendings(order_type, quantity, mov)
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
      if transform(pending, inventory, mov)
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
    bigger_than_entry = false
    related_warehouses(order_type).each do |entry|
      if total_quantity >= entry.fix_quantity

        bigger_than_entry = true
        mov = entry.movement
        mov_sales = entry.movement.sales
        mov_sales << Movement.last unless mov_sales.include?(Movement.last)
        q = entry.fix_quantity
        c = entry.movement.fix_cost

        if Movement.last.quantity == nil
          Movement.last.update(entry_movement: mov, quantity: q, cost: c, total_cost: (c * q).round(2), discount_applied: (Movement.last.discount_applied * q).round(2), automatic_discount: (Movement.last.automatic_discount * q).round(2), taxes: (Movement.last.taxes * q).round(2), subtotal: (Movement.last.subtotal * q).round(2), total: (Movement.last.subtotal * q).round(2) - (Movement.last.discount_applied * q).round(2) + (Movement.last.taxes * q).round(2), initial_price: Movement.last.initial_price.round(2), final_price: Movement.last.final_price.round(2))
        end

        total_quantity -= Movement.last.quantity
        temp_quantity = Movement.last.quantity
        entry.destroy
      else
        bigger_than_entry = false
        mov = entry.movement
        mov_sales = entry.movement.sales
        mov_sales << Movement.last unless mov_sales.include?(Movement.last)
        q = total_quantity
        c = entry.movement.fix_cost

        if Movement.last.quantity == nil
          Movement.last.update(entry_movement: mov, quantity: q, cost: c, total_cost: (c * q).round(2), discount_applied: (Movement.last.discount_applied * q).round(2), automatic_discount: (Movement.last.automatic_discount * q).round(2), taxes: (Movement.last.taxes * q).round(2), subtotal: (Movement.last.subtotal * q).round(2), total: (Movement.last.subtotal * q).round(2) - (Movement.last.discount_applied * q).round(2) + (Movement.last.taxes * q).round(2), initial_price: Movement.last.initial_price.round(2), final_price: Movement.last.final_price.round(2))
        end

        temp_quantity = total_quantity
        entry.update(quantity: (entry.fix_quantity - total_quantity))
        total_quantity -= Movement.last.quantity
      end
      if bigger_than_entry
        split(nil, entry.movement.fix_cost)
      end
      get_product.update_inventory_quantity(
        temp_quantity
      )
      break if total_quantity == 0
    end
  rescue
    return false
  end

  class << self

    def initialize_with(object, user ,type)
      product = object.product
      store   = user.store
      discount = 0.35
      prospect = Prospect.find_by_store_prospect_id(store)
      disc_app = product.price * discount
      unit_price = product.price * (1 - discount)
      create(
        product: product,
        unique_code: product.unique_code,
        store: store,
        initial_price: product.price,
        automatic_discount: disc_app,
        discount_applied: disc_app,
        final_price: unit_price,
        taxes: unit_price * 0.16,
        subtotal: product.price,
        supplier: product.supplier,
        movement_type: type,
        user: user,
        business_unit: store.business_unit,
        prospect: prospect,
        product_request: object,
        tax: Tax.find(2)
      )
      if (user.role.name == 'store' || user.role.name == 'store-admin')
        Movement.last.update(buyer_user: user)
      else
        Movement.last.update(seller_user: user)
      end
    end

  end
end
