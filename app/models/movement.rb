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

  after_create :create_update_summary
  after_create :vinculate_warehouse, :check_for_pendings, if: :is_entry_movement

  def create_update_summary
    if (self.movement_type == 'venta' || self.movement_type == 'devolución')
      if dont_exist_prospect_sale
        create_prospect_report
      else
        update_prospect_report
      end
      if dont_exist_product_sale
        create_product_report
      else
        update_product_report
      end
      if dont_exist_store_sale
        create_store_report
      else
        update_store_report
      end
      if dont_exist_business_unit_sale
        create_business_unit_report
      else
        update_business_unit_report
      end
      if dont_exist_business_group_sale
        create_business_group_report
      else
        update_business_group_report
      end
    end
  end

  def dont_exist_product_sale
    !!(ProductSale.where(month: Date.today.month, year: Date.today.year, store: store, product: product).first.nil?)
  end

  def dont_exist_prospect_sale
    !!(ProspectSale.where(month: Date.today.month, year: Date.today.year, store: store, prospect: prospect).first.nil?)
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: Date.today.month, year: Date.today.year, store: store).first.nil?)
  end

  def dont_exist_business_unit_sale
    !!(BusinessUnitSale.where(month: Date.today.month, year: Date.today.year, business_unit: self.store.business_unit).first.nil?)
  end

  def dont_exist_business_group_sale
    !!(BusinessGroupSale.where(month: Date.today.month, year: Date.today.year, business_group: self.store.business_unit.business_group).first.nil?)
  end

  def create_business_group_report
    create_reports_data(
      BusinessGroupSale
    ).update(
      business_group: self.store.business_unit.business_group
    )
  end

  def create_business_unit_report
    create_reports_data(
      BusinessUnitSale
    ).update(
      business_unit: self.store.business_unit
    )
  end

  def create_store_report
    create_reports_data(
      StoreSale
    ).update(
      store: store
    )
  end

  def create_product_report
    create_reports_data(
      ProductSale
    ).update(
      product: product
    )
  end

  def create_prospect_report
    create_reports_data(
      ProspectSale
    ).update(
      prospect: prospect
    )
  end

  def update_business_group_report
    update_reports_data(
      BusinessGroupSale.where(month: Date.today.month, year: Date.today.year, business_group: self.store.business_unit.business_group).first
    )
  end

  def update_business_unit_report
    update_reports_data(
      BusinessUnitSale.where(month: Date.today.month, year: Date.today.year, business_unit: self.store.business_unit).first
    )
  end

  def update_store_report
    update_reports_data(
      StoreSale.where(month: Date.today.month, year: Date.today.year, store: store).first
    )
  end

  def update_prospect_report
    update_reports_data(
      ProspectSale.where(month: Date.today.month, year: Date.today.year, prospect: prospect, store: store).first
    )
  end

  def update_product_report
    update_reports_data(
      ProductSale.where(month: Date.today.month, year: Date.today.year, product: product, store: store).first
    )
  end

  def update_reports_data(object)
    subtotal = self.subtotal.to_f
    discount = self.discount_applied.to_f
    taxes = self.taxes.to_f
    total = self.total.to_f
    quantity = self.quantity.to_i
    cost = self.total_cost.to_f
    if self.movement_type == 'venta'
      object.update_attributes(
        subtotal: object.subtotal.to_f + subtotal,
        discount: object.discount.to_f + discount,
        taxes: object.taxes.to_f + taxes,
        total: object.total.to_f + total,
        cost: object.cost.to_f + cost,
        quantity: object.quantity.to_i + quantity,
      )
    else
      object.update_attributes(
        subtotal: object.subtotal.to_f - subtotal,
        discount: object.discount.to_f - discount,
        taxes: object.taxes.to_f - taxes,
        total: object.total.to_f - total,
        cost: object.cost.to_f - cost,
        quantity: object.quantity.to_i - quantity,
      )
    end
    object
  end

  def create_reports_data(object)
    subtotal = self.subtotal.to_f
    discount = self.discount_applied.to_f
    taxes = self.taxes.to_f
    total = self.total.to_f
    quantity = self.quantity.to_i
    cost = self.total_cost.to_f
    month = Date.today.month
    year  = Date.today.year
    store = self.store
    if self.movement_type == 'venta'
      object.create(
        subtotal: subtotal,
        discount: discount,
        taxes: taxes,
        total: total,
        cost: cost,
        quantity: quantity,
        month: month,
        year: year
      )
    else
      object.create(
        subtotal: - subtotal,
        discount: - discount,
        taxes: - taxes,
        total: - total,
        cost: - cost,
        quantity: - quantity,
        month: month,
        year: year
      )
    end
  end

  def business_unit
     BusinessUnit.find(
       self.store.business_unit_id
     )
  end

  def fix_cost
    self.cost.to_f || 0
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

  def actual_inventory
    get_product.inventory.quantity || 0
  end

  def related_warehouses(object)
    WarehouseEntry.where(
      product: object
    ).order(:id)
  end

  def is_entry_movement
    !!(self.movement_type == 'alta')
  end

  def check_for_pendings
    product = self.product
    quantity = product.inventory.quantity
    pendings = PendingMovement.where(product: product)
    pendings.each do |pending|
      unless pending.quantity <= 0
        if self.product.classification == 'especial'
          pending.update(quantity: self.quantity)
          pending.product_request.order.request.update(status: 'mercancía asignada')
          if self.quantity > pending.product_request.quantity
            pending.product_request.update(excess: self.quantity - pending.product_request.quantity, quantity: self.quantity)
          elsif self.quantity < pending.product_request.quantity
            # surplus va a ser escasés o faltante (lo contrario de su significado real)
            pending.product_request.update(surplus: pending.product_request.quantity - self.quantity, quantity: self.quantity)
          end
        end
        if quantity >= pending.quantity
          generate_objects_instance(pending)
          pending.destroy
        end
      end
    end
  end

  def update_movement_and_requests(movement)
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
  end

  def generate_objects_instance(object)
    @model_collection = []
    # Genera Movements, Altera warehouses e Inventories
    if object.class == PendingMovement
      hash = remove_attributes(object.attributes)
      product = Product.find(hash["product_id"])
    else
      hash = object
      product = hash["product"]
    end
    hash_1 = hash.dup
    total_quantity = hash_1["quantity"]
    product.inventory.update(quantity: product.inventory.quantity - total_quantity)
    WarehouseEntry.where(product: product).order(:id).each do |entry|
      hash_1 = hash.dup
      mov_sales = entry.movement.sales
      mov = entry.movement
      hash_1["entry_movement"] = mov
      if product.group
        hash_1["kg"] = mov.kg
        hash_1["identifier"] = mov.identifier
      end
      cost = ('%.2f' % mov.cost.to_f).to_f
        if total_quantity >= entry.fix_quantity
        q = entry.fix_quantity
        hash_1["quantity"] = q
        hash_1["cost"] = cost
        hash_1["total_cost"] = (cost * q).round(2)
        unless hash_1["subtotal"] == nil
          subtotal = hash_1["subtotal"]
          actual_subtotal = (subtotal * q).round(2)
          discount = hash_1["discount_applied"]
          actual_discount = (discount * q).round(2)
          if product.group
            actual_subtotal = (subtotal * q * mov.kg).round(2)
            actual_discount = (discount * q * mov.kg).round(2)
            hash_1["total_cost"] = (cost * q * mov.kg).round(2)
          end
          hash_1["subtotal"] = actual_subtotal
          hash_1["discount_applied"] = actual_discount
          hash_1["automatic_discount"] = actual_discount
          to_appy_taxes = ((actual_subtotal - actual_discount) * 0.16).round(2)
          actual_taxes = to_appy_taxes
          hash_1["taxes"] = actual_taxes
          hash_1["total"] = actual_subtotal - actual_discount + actual_taxes
        end
        Movement.create(hash_1)
        update_movement_and_requests(Movement.last) unless Movement.last.movement_type == 'baja'
        mov_sales << Movement.last unless mov_sales.include?(Movement.last)
        @model_collection << Movement.last.id
        total_quantity -= Movement.last.quantity
        entry.destroy
      else
        q = total_quantity
        hash_1["quantity"] = q
        hash_1["cost"] = cost
        hash_1["total_cost"] = (cost * q).round(2)
        unless hash_1["subtotal"] == nil
          subtotal = hash_1["subtotal"]
          actual_subtotal = (subtotal * q).round(2)
          discount = hash_1["discount_applied"]
          actual_discount = (discount * q).round(2)
          if product.group
            actual_subtotal = (subtotal * q * mov.kg).round(2)
            actual_discount = (discount * q * mov.kg).round(2)
            hash_1["total_cost"] = (cost * q * mov.kg).round(2)
          end
          hash_1["subtotal"] = actual_subtotal
          hash_1["discount_applied"] = actual_discount
          hash_1["automatic_discount"] = actual_discount
          to_appy_taxes = ((actual_subtotal - actual_discount) * 0.16).round(2)
          actual_taxes = to_appy_taxes
          hash_1["taxes"] = actual_taxes
          hash_1["total"] = actual_subtotal - actual_discount + actual_taxes
        end
        Movement.create(hash_1)
        update_movement_and_requests(Movement.last) unless Movement.last.movement_type == 'baja'
        @model_collection << Movement.last.id
        mov_sales << Movement.last unless mov_sales.include?(Movement.last)
        entry.update(quantity: entry.quantity - total_quantity)
        total_quantity -= Movement.last.quantity
      end
      break if total_quantity == 0
    end
    return @model_collection
  end

  def vinculate_warehouse
    WarehouseEntry.last.update(movement: self)
  end

  class << self

    def update_movement_and_requests_for_class(movement)
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
    end

    def generate_objects(object)
      @model_collection = []
      # Genera Movements, Altera warehouses e Inventories
      if object.class == PendingMovement
        hash = remove_attributes(object)
      else
        hash = object
      end
      hash_1 = hash.dup
      total_quantity = hash_1["quantity"]
      product = hash_1["product"]
      product.inventory.update(quantity: product.inventory.quantity - total_quantity)
      WarehouseEntry.where(product: product).order(:id).each do |entry|
        hash_1 = hash.dup
        mov_sales = entry.movement.sales
        mov = entry.movement
        hash_1["entry_movement"] = mov
        if product.group
          hash_1["kg"] = mov.kg
          hash_1["identifier"] = mov.identifier
        end
        cost = ('%.2f' % mov.cost.to_f).to_f
        if total_quantity >= entry.fix_quantity
          q = entry.fix_quantity
          hash_1["quantity"] = q
          hash_1["cost"] = cost
          hash_1["total_cost"] = (cost * q).round(2)
          unless hash_1["subtotal"] == nil
            subtotal = hash_1["subtotal"]
            actual_subtotal = (subtotal * q).round(2)
            discount = hash_1["discount_applied"]
            actual_discount = (discount * q).round(2)
            if product.group
              actual_subtotal = (subtotal * q * mov.kg).round(2)
              actual_discount = (discount * q * mov.kg).round(2)
              hash_1["total_cost"] = (cost * q * mov.kg).round(2)
            end
            hash_1["subtotal"] = actual_subtotal
            hash_1["discount_applied"] = actual_discount
            hash_1["automatic_discount"] = actual_discount
            to_appy_taxes = ((actual_subtotal - actual_discount) * 0.16).round(2)
            actual_taxes = to_appy_taxes
            hash_1["taxes"] = actual_taxes
            hash_1["total"] = actual_subtotal - actual_discount + actual_taxes
          end
          Movement.create(hash_1)
          if hash_1.class == Hash
            update_movement_and_requests_for_class(Movement.last) unless Movement.last.movement_type == 'baja'
          else
            update_movement_and_requests(Movement.last) unless Movement.last.movement_type == 'baja'
          end
          mov_sales << Movement.last unless mov_sales.include?(Movement.last)
          @model_collection << Movement.last.id
          total_quantity -= Movement.last.quantity
          entry.destroy
        else
          q = total_quantity
          hash_1["quantity"] = q
          hash_1["cost"] = cost
          hash_1["total_cost"] = (cost * q).round(2)
          unless hash_1["subtotal"] == nil
            subtotal = hash_1["subtotal"]
            actual_subtotal = (subtotal * q).round(2)
            discount = hash_1["discount_applied"]
            actual_discount = (discount * q).round(2)
            if product.group
              actual_subtotal = (subtotal * q * mov.kg).round(2)
              actual_discount = (discount * q * mov.kg).round(2)
              hash_1["total_cost"] = (cost * q * mov.kg).round(2)
            end
            hash_1["subtotal"] = actual_subtotal
            hash_1["discount_applied"] = actual_discount
            hash_1["automatic_discount"] = actual_discount
            to_appy_taxes = ((actual_subtotal - actual_discount) * 0.16).round(2)
            actual_taxes = to_appy_taxes
            hash_1["taxes"] = actual_taxes
            hash_1["total"] = actual_subtotal - actual_discount + actual_taxes
          end
          Movement.create(hash_1)
          if hash.class == Hash
            update_movement_and_requests_for_class(Movement.last) unless Movement.last.movement_type == 'baja'
          else
            update_movement_and_requests(Movement.last) unless Movement.last.movement_type == 'baja'
          end
          @model_collection << Movement.last.id
          mov_sales << Movement.last unless mov_sales.include?(Movement.last)
          entry.update(quantity: entry.quantity - total_quantity)
          total_quantity -= Movement.last.quantity
        end
        break if total_quantity == 0
      end
      return @model_collection
    end

    def new_object(product_request, user, type, discount, prospect)
      product = product_request.product
      store = Store.find_by_store_name('Corporativo Compresor')
      prospect = prospect
      price = ('%.2f' % product.price).to_f
      disc_app = ('%.2f' % (product.price * discount)).to_f
      unit_price = ('%.2f' % (price * (1 - discount))).to_f
      cost = ('%.2f' % product.cost.to_f).to_f
      hash = Hash.new.tap do |hash|
        hash["product"] = product
        hash["quantity"] = product_request.quantity
        hash["unique_code"] = product.unique_code
        hash["store"] = store
        hash["order"] = product_request.order
        hash["initial_price"] = price
        hash["automatic_discount"] = disc_app
        hash["discount_applied"] = disc_app
        hash["final_price"] = unit_price
        hash["taxes"] = unit_price * 0.16
        hash["cost"] = cost
        hash["subtotal"] = product.price
        hash["supplier"] = product.supplier
        hash["movement_type"] = type
        hash["user"] = user
        hash["business_unit"] = store.business_unit
        hash["prospect"] = prospect
        hash["product_request"] = product_request
        hash["tax"] = Tax.find(2)
        if (user.role.name == 'store' || user.role.name == 'store-admin')
          hash["buyer_user"] = user
        else
          hash["seller_user"] = user
        end
      end
      if hash.class == Hash
        generate_objects(hash)
      else
        generate_objects_instance(hash)
      end
    end

  end

end
