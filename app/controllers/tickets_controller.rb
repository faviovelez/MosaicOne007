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
  end

  def sales
    store = Store.find(params[:store])
    month = params[:month]
    year = params[:year]
    @tickets = store.tickets.where('extract(month from created_at) = ? and extract(year from created_at) = ?', month, year).where(tickets: {parent_id: nil})
  end

  def process_incomming_data
    @tickets = Ticket.where(saved: [nil, false])
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
      ticket.update(saved: true)
    end
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

end
