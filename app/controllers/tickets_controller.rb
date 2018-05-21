class TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    store = current_user.store
    @tickets = store.tickets.where(parent:nil)
  end

  def select_month
    # Temporal en lo que hago la tabla que resuma ventas y tenga mes y año para filtrar (agregar margen y descuentos)
  end

  def sales_summary
    store = current_user.store
    @summaries = store.store_sales&.order(:id)
    unless @summaries == []
      cash_register = store.cash_registers.first
      @cash_register_name = cash_register.name
      @cash_register_balance = cash_register.balance
      last_ticket = store.tickets.last
      @last_ticket_number = last_ticket.ticket_number
      @last_ticket_date = last_ticket.created_at.to_date
      @last_ticket_hour = last_ticket.created_at.strftime("%I:%M %p")
    end
  end

  def closure_day
  end

  def select_day
  end

  def closure_day_detailed
  end

  def ticket_sales
  end

  def prospect_view
    @prospect = Prospect.find(params[:id])
  end

  def product_sales
  end

  def query_string
  end

  def select_store
    if (current_user.role.name == 'store-admin' || current_user.role.name == 'store-admin')
      store_id = Store.find(current_user.store.id).id
    else
      store_id = current_user.store.business_group.stores.pluck(:id).join(",")
    end
    return store_id
  end

  def queries_and_info_for_reports(store_id, initial, final)
    initial_date = initial.to_date.strftime('%F %H:%M:%S')
    final_date = final.to_date.strftime('%F 23:59:59')

    @query_prospects_string = "SELECT united_prospect_sales.id, united_prospect_sales.name, COALESCE(SUM(united_prospect_sales.quantity), 0) AS quantity, COALESCE(SUM(united_prospect_sales.subtotal), 0) AS subtotal, COALESCE(SUM(united_prospect_sales.taxes), 0) AS taxes, COALESCE(SUM(united_prospect_sales.discount), 0) AS discount, COALESCE(SUM(united_prospect_sales.total), 0) AS total, COALESCE(SUM(united_prospect_sales.cost), 0) AS cost, COALESCE((SUM(united_prospect_sales.total) - (SUM(united_prospect_sales.cost) * 1.16)), 0) AS margin FROM (SELECT id, CASE WHEN filtered_store_movements.legal_or_business_name = '' THEN 'Sin Nombre' WHEN filtered_store_movements.legal_or_business_name IS null THEN 'Público en General' ELSE filtered_store_movements.legal_or_business_name END AS name, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.subtotal, 0) AS subtotal, COALESCE(filtered_store_movements.taxes, 0) AS taxes, COALESCE(filtered_store_movements.discount, 0) AS discount, COALESCE(filtered_store_movements.total, 0) AS total, COALESCE(filtered_store_movements.cost, 0) AS cost, COALESCE((filtered_store_movements.total - (filtered_store_movements.cost * 1.16)), 0) AS margin FROM (SELECT COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.quantity WHEN movement_type = 'devolución' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.subtotal WHEN movement_type = 'devolución' THEN -store_movements.subtotal ELSE 0 END ), 0) AS subtotal, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.discount_applied WHEN movement_type = 'devolución' THEN -store_movements.discount_applied ELSE 0 END ), 0) AS discount, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.taxes WHEN movement_type = 'devolución' THEN -store_movements.taxes ELSE 0 END ), 0) AS taxes, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.total WHEN movement_type = 'devolución' THEN -store_movements.total ELSE 0 END ), 0) AS total, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.total_cost WHEN movement_type = 'devolución' THEN -store_movements.total_cost ELSE 0 END ), 0) AS cost, prospects.legal_or_business_name, prospects.id FROM store_movements LEFT JOIN prospects ON store_movements.prospect_id = prospects.id WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id = #{store_id} GROUP BY prospects.legal_or_business_name, prospects.id ORDER BY prospects.legal_or_business_name) AS filtered_store_movements UNION ALL SELECT id, CASE WHEN filtered_service_offereds.legal_or_business_name = '' THEN 'Sin Nombre' WHEN filtered_service_offereds.legal_or_business_name IS null THEN 'Público en General' ELSE filtered_service_offereds.legal_or_business_name END AS name, COALESCE(filtered_service_offereds.quantity, 0) AS quantity, COALESCE(filtered_service_offereds.subtotal, 0) AS subtotal, COALESCE(filtered_service_offereds.taxes, 0) AS taxes, COALESCE(filtered_service_offereds.discount, 0) AS discount, COALESCE(filtered_service_offereds.total, 0) AS total, COALESCE(filtered_service_offereds.cost, 0) AS cost, COALESCE((filtered_service_offereds.total - (filtered_service_offereds.cost * 1.16)), 0) AS margin FROM (SELECT COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.quantity WHEN service_type = 'devolución' THEN -service_offereds.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.subtotal WHEN service_type = 'devolución' THEN -service_offereds.subtotal ELSE 0 END ), 0) AS subtotal, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.discount_applied WHEN service_type = 'devolución' THEN -service_offereds.discount_applied ELSE 0 END ), 0) AS discount, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.taxes WHEN service_type = 'devolución' THEN -service_offereds.taxes ELSE 0 END ), 0) AS taxes, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.total WHEN service_type = 'devolución' THEN -service_offereds.total ELSE 0 END ), 0) AS total, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.total_cost WHEN service_type = 'devolución' THEN -service_offereds.total_cost ELSE 0 END ), 0) AS cost, prospects.legal_or_business_name, prospects.id FROM service_offereds LEFT JOIN prospects ON service_offereds.prospect_id = prospects.id WHERE service_offereds.created_at > '#{initial_date}' AND service_offereds.created_at < '#{final_date}' AND service_offereds.store_id = #{store_id} GROUP BY prospects.legal_or_business_name, prospects.id ORDER BY prospects.legal_or_business_name) AS filtered_service_offereds) AS united_prospect_sales GROUP BY united_prospect_sales.name, united_prospect_sales.id"

    @query_products_and_services_string = "SELECT id, unique_code, description, exterior_color_or_design, line, SUM(quantity) AS cant, SUM(subtotal) AS subtotal, SUM(taxes) AS taxes, SUM(discount) AS discount, SUM(total) AS total, SUM(cost) AS cost, SUM(margin) AS margin FROM (SELECT * FROM(SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, filtered_store_movements.quantity AS quantity, filtered_store_movements.subtotal AS subtotal, filtered_store_movements.taxes AS taxes, filtered_store_movements.discount AS discount, filtered_store_movements.total AS total, filtered_store_movements.cost AS cost, (filtered_store_movements.total - (filtered_store_movements.cost * 1.16)) AS margin FROM (SELECT store_movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.quantity WHEN movement_type = 'devolución' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.subtotal WHEN movement_type = 'devolución' THEN -store_movements.subtotal ELSE 0 END ), 0) AS subtotal, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.discount_applied WHEN movement_type = 'devolución' THEN -store_movements.discount_applied ELSE 0 END ), 0) AS discount, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.taxes WHEN movement_type = 'devolución' THEN -store_movements.taxes ELSE 0 END ), 0) AS taxes, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.total WHEN movement_type = 'devolución' THEN -store_movements.total ELSE 0 END ), 0) AS total, COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.total_cost WHEN movement_type = 'devolución' THEN -store_movements.total_cost ELSE 0 END ), 0) AS cost FROM store_movements WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{store_id}) GROUP BY store_movements.product_id ORDER BY store_movements.product_id) AS filtered_store_movements RIGHT JOIN stores_inventories ON stores_inventories.product_id = filtered_store_movements.product_id LEFT JOIN products ON filtered_store_movements.product_id = products.id WHERE stores_inventories.store_id IN (#{store_id}) ORDER BY products.id) AS filtered WHERE quantity > 0 UNION ALL SELECT services.id, services.unique_code, services.description, '' AS exterior_color_or_design, COALESCE(services.delivery_company, 'Servicios'), filtered_service_offereds.quantity AS quantity, filtered_service_offereds.subtotal AS subtotal, filtered_service_offereds.taxes AS taxes, filtered_service_offereds.discount AS discount, filtered_service_offereds.total AS total, filtered_service_offereds.cost AS cost, (filtered_service_offereds.total - (filtered_service_offereds.cost * 1.16)) AS margin FROM (SELECT service_offereds.service_id, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.quantity WHEN service_type = 'devolución' THEN -service_offereds.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.subtotal WHEN service_type = 'devolución' THEN -service_offereds.subtotal ELSE 0 END ), 0) AS subtotal, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.discount_applied WHEN service_type = 'devolución' THEN -service_offereds.discount_applied ELSE 0 END ), 0) AS discount, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.taxes WHEN service_type = 'devolución' THEN -service_offereds.taxes ELSE 0 END ), 0) AS taxes, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.total WHEN service_type = 'devolución' THEN -service_offereds.total ELSE 0 END ), 0) AS total, COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.total_cost WHEN service_type = 'devolución' THEN -service_offereds.total_cost ELSE 0 END ), 0) AS cost FROM service_offereds WHERE service_offereds.created_at > '#{initial_date}' AND service_offereds.created_at < '#{final_date}' AND service_offereds.store_id IN (#{store_id}) GROUP BY service_offereds.service_id ORDER BY service_offereds.service_id) AS filtered_service_offereds LEFT JOIN services ON filtered_service_offereds.service_id = services.id ) AS final GROUP BY id, unique_code, description, exterior_color_or_design, line"
  end

## Es necesario mantener la query (fechas, tienda) para el reporte de clientes CREAR QUERY PARA EL SALDO, VENTAS Y PAGOS Y USAR UNA QUERY RAILS WAY PARA OBTENER LOS TICKETS, DEVOLUCIONES PAGOS DE ESE CLIENTE

  def temporal_method
    prospect = ''
    store = Store.find(3)

     @prospect.legal_or_business_name
     @first_sale
     @last_sale
     @sales_times
     @total_sales
     @total_payments
     @total_sales - @total_payments
     @sales_quantity
     @average_sale
    initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
    final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')

    @tickets = Ticket.includes(:prospect, :payments, children: :payments).where(store: store, tickets: {parent_id: nil}, created_at: initial_date..final_date, prospect: prospect).order(:ticket_number)

    @tickets = Ticket.where(store: store, tickets: {parent_id: nil}, created_at: initial_date..final_date, prospect_id: prospects).order(:ticket_number)

  end

  def no_payment
    @tickets = Ticket.where(store: current_user.store, ticket_type: 'venta', payed: false)
  end

  def saved
    @tickets = Ticket.where(store: current_user.store).where("ticket_type LIKE ? OR ticket_type LIKE?", "%guardado%", "%pending%")
  end

  def cancelled_tickets
    @tickets = current_user.store.tickets.where(ticket_type: 'cancelado')
  end

  def get_date
    store_id = select_store
    if params[:options] == 'Seleccionar día'
      date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
      initial_date = date.midnight + 6.hours
      final_date = date.end_of_day + 6.hours
    elsif params[:options] == 'Mes actual'
      initial_date = Date.today.beginning_of_month.midnight + 6.hours
      final_date = Date.today + 6.hours
    else
      initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
      final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
    end
    if (params[:report_type] == 'Resumido' || params[:report_type] == 'Detallado')
      @tickets = Ticket.includes(:bill, :payments, :store_movements, :service_offereds, children: :payments).where(created_at: initial_date..final_date, store: store_id, ticket_type: ['venta', 'devolución', 'pago']).order(:ticket_number)
      if @tickets == []
        redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
      else
        @month_tickets = Ticket.includes(:store_movements, :service_offereds, :payments, children: :payments).where(created_at: (Date.today.beginning_of_month.midnight + 6.hours)..(Time.now + 6.hours), ticket_type: ['venta', 'devolución'], store: store_id)
        get_payments_from_ticket_day
        get_summary_from_ticket_day
        if params[:report_type] == 'Detallado'
          render 'closure_day_detailed'
        else
          render 'closure_day'
        end
      end
    else
      queries_and_info_for_reports(store_id, initial_date, final_date)
      if params[:report_type] == 'Por cliente'
        @prospects = Prospect.find_by_sql(@query_prospects_string)
        if @prospects == []
          redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
        else
          render 'prospect_sales'
        end
      else
        @products = Product.find_by_sql(@query_products_and_services_string)
        if @products == []
          redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
        else
          render 'product_sales'
        end
      end
    end
  end

  def get_payments_from_ticket_day
    first = @tickets.first.created_at.to_date.beginning_of_month.midnight + 6.hours
    second = Time.now + 6.hours
    @month_tickets = current_user.store.tickets.where(created_at: (first)..(second)).where(ticket_type: ['venta', 'devolución'])
    @cash = ['Efectivo', 0, []]
    @credit_card = ['Tarjeta de crédito', 0, []]
    @debit_card = ['Tarjeta de débito', 0, []]
    @check = ['Cheque', 0, []]
    @transfer = ['Transferencia', 0, []]
    @credit_sales = ['Ventas a crédito', 0, []]
    @total_payment_forms = 0
    @payment_forms = []
    @tickets.each do |ticket|
      ticket.payments.each do |payment|
        if payment.payment_form.description == 'Efectivo'
          if payment.payment_type == 'pago'
            @cash[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @cash[1] -= payment.total
          end
          @cash[2] << payment.ticket.ticket_number unless @cash[2].include?(payment.ticket.ticket_number)
        elsif payment.payment_form.description == 'Cheque nominativo'
          if payment.payment_type == 'pago'
            @check[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @check[1] -= payment.total
          end
          @check[2] << payment.ticket.ticket_number unless @check[2].include?(payment.ticket.ticket_number)
        elsif payment.payment_form.description == 'Transferencia electrónica de fondos'
          if payment.payment_type == 'pago'
            @transfer[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @transfer[1] -= payment.total
          end
          @transfer[2] << payment.ticket.ticket_number unless @transfer[2].include?(payment.ticket.ticket_number)
        elsif payment.payment_form.description == 'Tarjeta de crédito'
          if payment.payment_type == 'pago'
            @credit_card[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @credit_card[1] -= payment.total
          end
          @credit_card[2] << payment.ticket.ticket_number unless @credit_card[2].include?(payment.ticket.ticket_number)
        elsif payment.payment_form.description == 'Tarjeta de débito'
          if payment.payment_type == 'pago'
            @debit_card[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @debit_card[1] -= payment.total
          end
          @debit_card[2] << payment.ticket.ticket_number unless @debit_card[2].include?(payment.ticket.ticket_number)
        elsif payment.payment_form.description == 'Por definir'
          if payment.payment_type == 'pago'
            @credit_sales[1] += payment.total
          elsif payment.payment_type == 'devolución'
            @credit_sales[1] -= payment.total
          end
          @credit_sales[2] << payment.ticket.ticket_number unless @credit_sales[2].include?(payment.ticket.ticket_number)
        end
      end
    end
    @payment_forms << @debit_card
    @payment_forms << @check
    @payment_forms << @cash
    @payment_forms << @credit_card
    @payment_forms << @transfer
    @payment_forms << @credit_sales
    @payment_forms.each do |pay|
      @total_payment_forms += pay[1]
    end
  end

  def closure_day_pdf
    get_date
    pdf = render_to_string pdf: "closure_day_pdf", template: 'tickets/closure_day_pdf', page_size: 'Letter', layout: 'closure.html', encoding: "UTF-8"
    save_path = Rails.root.join('public', 'uploads', 'closures', "#{@store.id}", 'cierre.pdf')
    pdf_bill = File.open(save_path, 'wb'){ |file| file << pdf }
    @pdf = pdf_bill
  end

  def get_summary_from_ticket_day
    @day_pieces = 0
    @day_total = 0
    @day_subtotal = 0
    @day_taxes = 0
    @day_average = 0
    @day_payments = 0
    @day_discount = 0
    @month_pieces = 0
    @month_total = 0
    @month_average = 0
    @tickets.each do |ticket|
      ticket.payments.each do |pay|
        if pay.payment_type == 'devolución'
          @day_payments -= pay.total
        elsif pay.payment_type == 'pago'
          @day_payments += pay.total
        end
      end
      ticket.store_movements.each do |sm|
        if sm.movement_type == 'devolución'
          @day_pieces -= sm.quantity
          @day_total -= sm.total
          @day_subtotal -= sm.subtotal
          @day_taxes -= sm.taxes
          @day_discount -= sm.discount_applied
        elsif sm.movement_type == 'venta'
          @day_pieces += sm.quantity
          @day_total += sm.total
          @day_subtotal += sm.subtotal
          @day_taxes += sm.taxes
          @day_discount += sm.discount_applied
        end
      end
      ticket.service_offereds.each do |so|
        if so.service_type == 'devolución'
          @day_pieces -= so.quantity
          @day_total -= so.total
          @day_subtotal -= so.subtotal
          @day_taxes -= so.taxes
          @day_discount -= so.discount_applied
        elsif so.service_type == 'venta'
          @day_pieces += so.quantity
          @day_total += so.total
          @day_subtotal += so.subtotal
          @day_taxes += so.taxes
          @day_discount += so.discount_applied
        end
      end
    end
    @month_tickets.each do |ticket|
      ticket.store_movements.each do |sm|
        if sm.movement_type == 'devolución'
          @month_pieces -= sm.quantity
          @month_total -= sm.total
        elsif sm.movement_type == 'venta'
          @month_pieces += sm.quantity
          @month_total += sm.total
        end
      end
      ticket.service_offereds.each do |so|
        if so.service_type == 'devolución'
          @month_pieces -= so.quantity
          @month_total -= so.total
        elsif so.service_type == 'venta'
          @month_pieces += so.quantity
          @month_total += so.total
        end
      end
    end
    month_tickets = @month_tickets.count - @month_tickets.where(ticket_type: 'pago').count
    day_tickets = @tickets.count - @tickets.where(ticket_type: 'pago').count
    @average_day_total = @day_total / day_tickets
    @average_month_total = @month_total / month_tickets
    @average_day_pieces = @day_pieces / day_tickets
    @average_month_pieces = @month_pieces / month_tickets
  end

  def sales
    store = Store.find(params[:store])
    month = params[:month]
    year = params[:year]
    @tickets = Ticket.includes(:bill, :prospect, :payments, store_movements: :product, service_offereds: :service, children: [:payments, store_movements: :product, service_offereds: :service]).where(store: store).where(
      'extract(month from created_at) = ? and extract(year from created_at) = ?',
      month, year
    ).where(tickets: {parent_id: nil, ticket_type: 'venta'})
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
    @ticket = Ticket.includes(store_movements: :product, service_offereds: :service).find(params[:id])
    @number = @ticket.ticket_number
    @date = @ticket.created_at.to_date
    unless @ticket.user == nil
      @user = @ticket.user.first_name + ' ' + @ticket.user.last_name
    end
    @prospect = @ticket&.prospect&.legal_or_business_name
    unless @ticket.cash_register == nil
      @register = 'Caja ' + @ticket.cash_register.name
    end
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
    @total_rows_ticket = 0
    @rows.each do |row|
      if row["type"] == 'venta'
        @total_rows_ticket += row["total"]
      elsif row["type"] == 'devolución'
        @total_rows_ticket -= row["total"]
      end
    end
    @total_rows_ticket
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
    @total_payments_ticket = 0
    @ticket.payments.each do |payment|
      unless payment.payment_type == 'crédito'
        @payments_ticket << payment
        if payment.payment_type == 'pago'
          @total_payments_ticket += payment.total
        elsif payment.payment_type == 'devolución'
          @total_payments_ticket -= payment.total
        end
      end
    end
    @ticket.children.each do |ticket|
      ticket.payments.each do |payment|
        unless payment.payment_type == 'crédito'
          @payments_ticket << payment
          if payment.payment_type == 'pago'
            @total_payments_ticket += payment.total
          elsif payment.payment_type == 'devolución'
            @total_payments_ticket -= payment.total
          end
        end
      end
    end
    @total_payments_ticket
  end

end
