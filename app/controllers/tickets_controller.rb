class TicketsController < ApplicationController

  def index
    # Cambiar a resumen de ventas
    store = current_user.store
    @tickets = store.tickets.where(parent:nil)
  end

  def select_month
    # Temporal en lo que hago la tabla que resuma ventas y tenga mes y año para filtrar (agregar margen y descuentos)
  end

  def sales_summary
    store = current_user.store
    @summaries = store.store_sales.order(:id)
    cash_register = store.cash_registers.first
    @cash_register_name = cash_register.name
    @cash_register_balance = cash_register.balance
    last_ticket = store.tickets.last
    @last_ticket_number = last_ticket.ticket_number
    @last_ticket_date = last_ticket.created_at.to_date
    @last_ticket_hour = last_ticket.created_at.strftime("%I:%M %p")
  end

  def sales
    store = Store.find(params[:store])
    month = params[:month]
    year = params[:year]
    @tickets = store.tickets.where(
    'extract(month from created_at) = ? and extract(year from created_at) = ?',
    month, year
    ).where(tickets: {parent_id: nil})
  end

  def process_incomming_data
    # Confirmar si va a entrar tienda por tienda
    @tickets = Ticket.where(saved: [nil, false])
    store = @tickets.first.store
    @tickets.each do |ticket|
      ticket.store_movements.each do |mov|
        @mov = mov
        validate_if_summary_exists(@mov)
      end
      ticket.service_offereds.each do |serv|
        @mov = serv
        validate_if_summary_exists(@mov)
      end
      ticket.payments.each do |pay|
        unless pay.payment_form.description == 'Por definir'
          @pay = pay
          if store_sale(@pay) == nil
            create_only_payments(@pay)
          else
            update_only_payments(@pay, store_sale(@pay))
          end
        end
      end
      ticket.update(saved: true) # pos: false ?? Validar si puede actualizarse en 2 vías
    end
    store.stores_inventories.each do |inventory|
      process_store_inventories(inventory)
    end
  end

  def process_store_inventories(inventory)
    # Usar una lógica similar para inventories (de diseños de cartón)
    get_desired_inventory(inventory)
    change_alert(inventory, @actual_stock, @desired_inventory, @reorder_quantity, @critical_quantity)
    send_mail_to_alert(inventory)
  end

  def get_desired_inventory(inventory)
    product = inventory.product
    store = inventory.store
    months = store.months_in_inventory
    date = Date.today
    reorder = store.reorder_point / 100
    critical = store.critical_point / 100
    @actual_stock = inventory.quantity

    @desired_inventory = 0
    for i in 1..months
      quantity = ProductSale.where(
        product: product,
        store: store,
        month: date.month,
        year: date.year
      ).quantity
      @desired_inventory += quantity
      date -= 1.month
    end
    @desired_inventory
    @reorder_quantity = (@desired_inventory * reorder).to_i
    @critical_quantity = (@desired_inventory * critical).to_i
  end

  def change_alert(inventory, stock, desired, reorder, critical)
    @alert = false
    if (stock <= reorder && stock > critical)
      alert_changed_to_true(inventory)
      inventory.update(alert: true, alert_type: 'bajo')
    elsif stock <= critical
      alert_changed_to_true(inventory)
      inventory.update(alert: true, alert_type: 'crítico')
    else
      inventory.update(alert: false, alert_type: nil)
    end
  end

  def alert_changed_to_true(inventory)
    @changed = false
    if inventory.alert == false
      @changed = true
    end
    @changed
  end

  def send_mail_to_alert(inventory)
    # if @changed == true
  end

  def validate_if_summary_exists(mov)
    if mov.is_a?(StoreMovement)
      if product_sale(mov) == nil
        create_product_sale(mov)
      else
        update_product_sale(mov, product_sale(mov))
      end
    else
      if service_sale(mov) == nil
        create_service_sale(mov)
      else
        update_service_sale(mov, service_sale(mov))
      end
    end

    unless mov.ticket.prospect == nil
      if prospect_sale(mov) == nil
        create_prospect_sale(mov)
      else
        update_prospect_sale(mov, prospect_sale(mov))
      end
    end

    if store_sale(mov) == nil
      create_store_sale(mov)
    else
      update_store_sale(mov, store_sale(mov))
    end

    if business_unit_sale(mov) == nil
      create_business_unit_sale(mov)
    else
      update_business_unit_sale(mov, business_unit_sale(mov))
    end

    if business_group_sale(mov) == nil
      create_business_group_sale(mov)
    else
      update_business_group_sale(mov, business_group_sale(mov))
    end
  end

  def business_unit_sale(mov)
    BusinessUnitSale.where(month: mov.created_at.month, year: mov.created_at.year, business_unit: mov.store.business_unit).first
  end

  def business_group_sale(mov)
    BusinessGroupSale.where(month: mov.created_at.month, year: mov.created_at.year, business_group: mov.store.business_unit.business_group).first
  end

  def prospect_sale(mov)
    ProspectSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, prospect: mov.ticket.prospect).first
  end

  def product_sale(mov)
    ProductSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, product: mov.product).first
  end

  def service_sale(mov)
    ServiceSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store, service: mov.service).first
  end

  def store_sale(mov)
    StoreSale.where(month: mov.created_at.month, year: mov.created_at.year, store: mov.store).first
  end

  def create_product_sale(mov)
    create_reports_data(mov, ProductSale)
  end

  def update_product_sale(mov, object)
    update_reports_data(mov, object)
  end

  def create_service_sale(mov)
    create_reports_data(mov, ServiceSale)
  end

  def update_service_sale(mov, object)
    update_reports_data(mov, object)
  end

  def create_prospect_sale(mov)
    create_reports_data(mov, ProspectSale)
  end

  def update_prospect_sale(mov, object)
    update_reports_data(mov, object)
  end

  def create_store_sale(mov)
    create_reports_data(mov, StoreSale)
  end

  def update_store_sale(mov, object)
    update_reports_data(mov, object)
  end

  def create_business_unit_sale(mov)
    create_reports_data(mov, BusinessUnitSale)
  end

  def update_business_unit_sale(mov, object)
    update_reports_data(mov, object)
  end

  def create_business_group_sale(mov)
    create_reports_data(mov, BusinessGroupSale)
  end

  def update_business_group_sale(mov, object)
    update_reports_data(mov, object)
  end

  def update_reports_data(mov, object)
    subtotal = mov.subtotal
    discount = mov.discount_applied
    taxes = mov.taxes
    total = mov.total
    quantity = mov.quantity
    cost = mov.total_cost.to_f
    object.update_attributes(
      subtotal: object.subtotal + subtotal,
      discount: object.discount + discount,
      taxes: object.taxes + taxes,
      total: object.total + total,
      cost: object.cost + cost,
      quantity: object.quantity + quantity
    )
  end

  def create_reports_data(mov, object)
    new_object = object.new(
      subtotal: mov.subtotal,
      discount: mov.discount_applied,
      taxes: mov.taxes,
      total: mov.total,
      cost: mov.total_cost.to_f,
      quantity: mov.quantity,
      month: mov.created_at.month,
      year: mov.created_at.year
    )
    new_object.save
    update_particular_fields(new_object, mov)
  end

  def update_particular_fields(object, mov)
    if object.is_a?(ProductSale)
      object.update(product: mov.product, store: mov.store, business_unit: mov.store.business_unit)
    elsif object.is_a?(ServiceSale)
      object.update(service: mov.service, store: mov.store)
    elsif object.is_a?(ProspectSale)
      object.update(prospect: mov.ticket.prospect, store: mov.store)
    elsif object.is_a?(StoreSale)
      object.update(store: mov.store)
    elsif object.is_a?(BusinessUnitSale)
      object.update(business_unit: mov.store.business_unit)
    elsif object.is_a?(BusinessGroupSale)
      object.update(business_group: mov.store.business_unit.business_group)
    end
  end

  def create_only_payments(pay)
    StoreSale.create(payments: pay.total, store: pay.store, month: pay.created_at.month, year: pay.created_at.year)
  end

  def update_only_payments(pay, object)
    payments = object.payments.to_f + pay.total
    object.update_attributes(payments: payments, store: pay.store)
  end

  def details
    @ticket = Ticket.find(params[:id])
    @number = @ticket.ticket_number
    @date = @ticket.created_at.to_date
    @user = @ticket.user.first_name + @ticket.user.las_name
    @prospect = @ticket&.prospect&.legal_or_business_name
    @register = 'Caja ' + @ticket.cash_register.name
    rows_for_ticket_show
    payments_for_ticket_show
  end

  def rows_for_ticket_show
    @rows = []
    @ticket.store_movements.each do |movement|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = movement.ticket.id
        hash["type"] = movement.movement_type
        hash["date"] = movement.created_at.to_date
        hash["unique_code"] = movement.product.unique_code
        hash["description"] = movement.product.description
        hash["color"] = movement.product.exterior_color_or_design
        hash["unit_value"] = movement.initial_price
        hash["quantity"] = movement.quantity
        hash["discount"] = movement.discount_applied
        hash["total"] = movement.total
      end
      @rows << hash
    end
    @ticket.service_offereds.each do |service|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = service.ticket.id
        hash["type"] = service.service_type
        hash["date"] = service.created_at.to_date
        hash["unique_code"] = service.service.unique_code
        hash["description"] = service.service.description
        hash["unit_value"] = service.initial_price
        hash["quantity"] = service.quantity
        hash["discount"] = service.discount_applied
        hash["total"] = service.total
      end
      @rows << hash
    end
    @ticket.children.each do |ticket|
      ticket.store_movements.each do |movement|
        hash = Hash.new.tap do |hash|
          hash["ticket"] = movement.ticket.id
          hash["type"] = movement.movement_type
          hash["date"] = movement.created_at.to_date
          hash["unique_code"] = movement.product.unique_code
          hash["description"] = movement.product.description
          hash["color"] = movement.product.exterior_color_or_design
          hash["unit_value"] = movement.initial_price
          hash["quantity"] = movement.quantity
          hash["discount"] = movement.discount_applied
          hash["total"] = movement.total
        end
        @rows << hash
      end
      ticket.service_offereds.each do |service|
        hash = Hash.new.tap do |hash|
          hash["ticket"] = service.ticket.id
          hash["type"] = service.service_type
          hash["date"] = service.created_at.to_date
          hash["unique_code"] = service.service.unique_code
          hash["description"] = service.service.description
          hash["unit_value"] = service.initial_price
          hash["quantity"] = service.quantity
          hash["discount"] = service.discount_applied
          hash["total"] = service.total
        end
        @rows << hash
      end
    end
    @rows
  end

  def ticket_details
    @ticket = Ticket.find(params[:id])
    @number = @ticket.ticket_number
    @date = @ticket.created_at.to_date
    @prospect = @ticket&.prospect&.legal_or_business_name
    @register = 'Caja ' + @ticket.cash_register.name
    rows_for_ticket_show
    payments_for_ticket_show
  end

  def payments_for_ticket_show
    @payments_ticket = []
    @ticket.payments.each do |payment|
      @payments_ticket << payment unless payment.payment_type == 'crédito'
    end
    @ticket.children.each do |ticket|
      ticket.payments.each do |payment|
        @payments_ticket << payment unless payment.payment_type == 'crédito'
      end
    end
    total = []
    @payments_ticket.each do |pay|
      total << pay.total
    end
    @total_payments_ticket = total.inject(&:+)
    @total_payments_ticket
  end

end
