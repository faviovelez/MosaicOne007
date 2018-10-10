class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show_for_store, :change_delivery_address]
  before_action :reverse_params_array, only: [:save_products, :save_products_for_prospects]

  def new(role = current_user.role.name)
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       prospect: Prospect.find_by_store_prospect_id(current_user.store)
                      )
    @order.users << current_user
    if (role == 'store' || role == 'store-admin')
      current_prospect_validation
      @due_debt = ActionController::Base.helpers.number_to_currency(@due_debt)
      redirect_to root_path, alert: "Presenta un saldo vencido de #{@due_debt} de #{@delay} días. Favor de ponerse al corriente para reestablecer el servicio" if (@delay > 10 && @due_debt)
    else
      redirect_to root_path, alert: 'No cuenta con los permisos necesarios.'
    end
  end

  def filter_for_viewers
  end

  def orders_for_viewers
  end

  def index_for_viewers
    current_orders
    render 'orders_for_viewers'
  end

  def pr_for_viewers
    @order = Order.find(params[:id])
  end

  def edit_discount
    @order = Order.find(params[:id])
  end

  def update_discount
    @orders = []
    order = ProductRequest.find(params[:id][0]).order
    @orders << order
    params[:id].each_with_index do |id, index|
      pr = ProductRequest.find(id)
      if pr.movements == []
        discount = (pr.pending_movement.subtotal * params[:final_discount][index].to_f / 100).round(2)
        taxes = ((pr.pending_movement.subtotal - discount) * 0.16).round(2)
        total = (pr.pending_movement.subtotal - discount + taxes).round(2)
        pr.pending_movement.update(final_price: params[:new_final_price][index].to_f, discount_applied: discount, manual_discount: discount, taxes: taxes, total: total)
      else
        pr.movements.each do |mov|
          discount = (mov.subtotal * params[:final_discount][index].to_f / 100).round(2)
          taxes = ((mov.subtotal - discount) * 0.16).round(2)
          total = (mov.subtotal - discount + taxes).round(2)
          mov.update(final_price: params[:new_final_price][index].to_f, discount_applied: discount, manual_discount: discount, taxes: taxes, total: total)
        end
      end
    end
    update_order_total
    redirect_to root_path, notice: "El pedido #{order.id} ha sido modificado."
  end

  def new_order_for_prospects(role = current_user.role.name)
    @prospect = Prospect.find(params[:prospect_id])
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       prospect: @prospect
                      )
    @order.users << current_user
    if (role == 'admin-desk')
      current_prospect_validation
      @due_debt = ActionController::Base.helpers.number_to_currency(@due_debt)
      redirect_to root_path, alert: "El cliente #{@prospect.legal_or_business_name} presenta un saldo vencido de #{@due_debt} de #{@delay} días. Favor de registrar los pagos necesarios para reestablecer el servicio" if (@delay > 10 && @due_debt)
    else
      redirect_to root_path, alert: 'No cuenta con los permisos necesarios.'
    end
  end

  def new_corporate(role = current_user.role.name)
    @order = Order.new(store: Store.find(2),
                       category: 'de línea',
                       prospect: Prospect.find_by_store_prospect_id(current_user.store)
                      )
    @order.users << current_user
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (role == 'admin-desk' || role == 'product-admin' || role == 'product-staff' || role == 'warehouse-staff' || role == 'warehouse-admin')
  end

  def current_prospect_validation
    if ['store', 'store-admin'].include?(current_user.role.name)
      prosp = current_user.store.store_prospect
    elsif (['admin-desk', 'product-admin', 'product-staff', 'warehouse-staff', 'warehouse-admin'].include?(current_user.role.name) && current_user.store.id == 1)
      prosp = Prospect.find(params[:prospect_id])
    else
      prosp = Store.find(2).store_prospect
    end
    credit = prosp.credit_days.to_i
    bills = Bill.where(payed: false, prospect: prosp, status: 'creada').pluck(:created_at, :total, :folio, :id)
    bills.each_with_index do |val, index|
      bill = Bill.find(val[3])
      bills[index] << bill.payments.sum(:total)
    end

    bills.each do |bill|
      bill[0] = bill[0].to_date + credit.days
    end

    @due_debt = 0
    @folios = ""
    @delay = 0
    bills.each_with_index do |val, index|
      if Date.today > val[0]
        this_delay = (Date.today - val[0]).to_i
        @delay =  this_delay if @delay < this_delay
        @due_debt += (val[1].to_f - val[4].to_f).round(2)
        if index == (bills.length - 1)
          string = val[2]
        else
          string = val[2] + "," + " "
        end
        @folios += string
      end
    end
  end

  def payment_report
  end

  def process_report
    report_parameters
    select_dates
    if params[:report_type] == 'Facturación por empresa'
      report_of_billing
    elsif params[:report_type] == 'Pagos por empresa'
      report_of_payment
    elsif params[:report_type] == 'Saldo por clientes'
      report_of_collection
    elsif params[:report_type] == 'Ventas por tienda'
      report_of_sales
    elsif params[:report_type] == 'Compras por tienda por mes'
      stores_buying_report
    elsif params[:report_type] == 'Comparativo compras por mes'
      monthly_report_stores
    elsif params[:report_type] == 'Facturas recibidas'
      bill_received_summary
    end
  end

  def bill_received_summary
    select_dates
    bills = BillReceived.joins(:supplier).joins('LEFT JOIN payments ON bill_receiveds.id = payments.bill_received_id').where(store_id: current_user.store_id).where(date_of_bill: @initial_date.to_date..@final_date.to_date).group("suppliers.name").pluck("suppliers.name, COUNT(DISTINCT bill_receiveds.id), SUM(bill_receiveds.total_amount), SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), array_agg(bill_receiveds.id), 'BillReceived'")
    if Store.where(store_type_id: 2).pluck(:id).include?(current_user.store.id)
      store_prospect = Prospect.where(store_prospect_id: current_user.store.business_unit.stores.pluck(:id)).pluck(:id).uniq
    else
      store_prospect = current_user.store.store_prospect.id
    end
    complement = Bill.joins(:prospect, :issuing_company).joins('LEFT JOIN payments ON bills.id = payments.bill_id').where(prospect_id: store_prospect, status: 'creada', created_at: @initial_date..@final_date).group('bills.issuing_company_id, billing_addresses.business_name').pluck("billing_addresses.business_name, COUNT(DISTINCT bills.id), SUM(bills.total), SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), array_agg(bills.id), 'Bill'")
    @bills = bills + complement
    @bill_receiveds = bills.map{ |arr| arr[4]}.flatten
    @normal_bills = complement.map{ |arr| arr[4]}.flatten
    render 'bill_received_summary'
  end

  def bill_received_extended_total
    @initial_date = Time.parse(params[:initial_date])
    @final_date = Time.parse(params[:final_date])
    if params[:bills].present?
      br_ids = params[:bill_receiveds].split('/')
      bills_receiveds = BillReceived.joins(:supplier).joins('LEFT JOIN payments ON bill_receiveds.id = payments.bill_received_id').where(id: br_ids).group("bill_receiveds.id, suppliers.name").pluck("bill_receiveds.id, bill_receiveds.folio, bill_receiveds.date_of_bill, suppliers.name, bill_receiveds.total_amount, SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), bill_receiveds.credit_days")
    end
    if params[:bill_receiveds].present?
      b_ids = params[:bills].split('/')
      bills = Bill.joins(:issuing_company, :prospect).joins('LEFT JOIN payments ON bills.id = payments.bill_id').where(id: b_ids).group('bills.id, bills.issuing_company_id, billing_addresses.business_name, prospects.credit_days').pluck("bills.id, CONCAT(bills.sequence, ' ', bills.folio), bills.created_at, billing_addresses.business_name, bills.total, SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), prospects.credit_days")
    end
    @bills = bills_receiveds + bills
    render 'bill_received_extended'
  end

  def bill_received_extended
    @initial_date = Time.parse(params[:initial_date])
    @final_date = Time.parse(params[:final_date])
    @ids = params[:ids].split('/')
    if params[:type] == 'BillReceived'
      @bills = params[:type].constantize.joins(:supplier).joins('LEFT JOIN payments ON bill_receiveds.id = payments.bill_received_id').where(id: @ids).group("bill_receiveds.id, suppliers.name").pluck("bill_receiveds.id, bill_receiveds.folio, bill_receiveds.date_of_bill, suppliers.name, bill_receiveds.total_amount, SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), bill_receiveds.credit_days")
    else
      @bills = params[:type].constantize.joins(:issuing_company, :prospect).joins('LEFT JOIN payments ON bills.id = payments.bill_id').where(id: @ids).group('bills.id, bills.issuing_company_id, billing_addresses.business_name, prospects.credit_days').pluck("bills.id, CONCAT(bills.sequence, ' ', bills.folio), bills.created_at, billing_addresses.business_name, bills.total, SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), prospects.credit_days")
    end
  end

  def report_parameters
    params[:companies].present? ? @billing_address = params[:companies].join(',') : @billing_address = current_user.store.business_unit.billing_address_id
    params[:companies].present? ? @store_id = BillingAddress.find(params[:companies].join(',')).stores.where(store_type: {store_type: 'corporativo'}).first.id : @store_id = current_user.store.id
    @prospect_id = params[:prospect_id]
  end

  def select_dates
    if params[:options] == 'Seleccionar día'
      date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
      @initial_date = date.midnight + 6.hours
      @final_date = date.end_of_day + 6.hours
    elsif params[:options] == 'Mes actual'
      @initial_date = Date.today.beginning_of_month.midnight + 6.hours
      @final_date = Date.today + 6.hours
    else
      @initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
      @final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
    end
  end

  def report_of_billing
    @billing_consolidated_query = "SELECT store_name, legal_or_business_name, COUNT(DISTINCT bills.id) AS count, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -subtotal WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN subtotal ELSE 0 END) AS subtotal, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -discount_applied WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN discount_applied ELSE 0 END) AS discount, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -taxes WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN taxes ELSE 0 END) AS taxes, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -bills.total WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN bills.total ELSE 0 END) AS total, prospects.id FROM bills INNER JOIN stores ON bills.store_id = stores.id INNER JOIN prospects ON bills.prospect_id = prospects.id WHERE bills.store_id = #{@store_id} AND bills.status = 'creada' AND bills.created_at > '#{@initial_date}' AND bills.created_at < '#{@final_date}' GROUP BY legal_or_business_name, store_name, prospects.id"

    if params[:extended_billing].present?
      @bills = Bill.joins(:prospect, :store).joins('LEFT JOIN orders ON orders.bill_id = bills.id').where(store_id: @store_id, status: 'creada', created_at: @initial_date..@final_date).group("stores.store_name,  prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), prospects.id").order('bills.id').pluck("stores.store_name,  prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), array_agg(orders.id), prospects.id")
      render 'billing_report_extended'
    elsif params[:extended_prospect_billing].present?
      @bills = Bill.joins(:prospect, :store).joins('LEFT JOIN orders ON orders.bill_id = bills.id').where(store_id: @store_id, status: 'creada', created_at: @initial_date..@final_date, prospect_id: params[:prospect_id]).group("stores.store_name,  prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), prospects.id").order('bills.id').pluck("stores.store_name,  prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), array_agg(orders.id)")
      render 'billing_report_extended'
    else
      @bills = Bill.connection.select_all(@billing_consolidated_query).rows
      render 'billing_report'
    end
  end

  def report_of_collection
    @collection_consolidated_query = "SELECT store_name, legal_or_business_name, COUNT(DISTINCT bills.id) AS count, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -subtotal WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN subtotal ELSE 0 END) AS subtotal, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -discount_applied WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN discount_applied ELSE 0 END) AS discount, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -taxes WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN taxes ELSE 0 END) AS taxes, SUM(DISTINCT CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -bills.total WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN bills.total ELSE 0 END) AS total, SUM(CASE WHEN payment_type = 'pago' THEN payments.total WHEN payment_type = 'devolución' THEN -payments.total ELSE 0 END) AS payments, prospects.id FROM bills INNER JOIN stores ON bills.store_id = stores.id INNER JOIN prospects ON bills.prospect_id = prospects.id LEFT JOIN payments ON payments.bill_id = bills.id WHERE bills.store_id = #{@store_id} AND bills.status = 'creada' AND bills.created_at > '#{@initial_date}' AND bills.created_at < '#{@final_date}' GROUP BY legal_or_business_name, store_name, prospects.id"

    if params[:extended_collection].present?
      @bills = Bill.uniq.joins(:store, :prospect).joins('LEFT JOIN payments ON payments.bill_id = bills.id LEFT JOIN orders ON orders.bill_id = bills.id').where("bills.store_id = #{@store_id}").where(created_at: @initial_date..@final_date).order('bills.id').group('stores.store_name, prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, prospects.credit_days').pluck("stores.store_name, prospects.legal_or_business_name, bills.bill_folio_type, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, SUM(CASE WHEN payment_type = 'pago' THEN payments.total WHEN payment_type = 'devolución' THEN -payments.total ELSE 0 END), CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), (DATE_TRUNC('DAY', bills.created_at) + CAST(COALESCE(prospects.credit_days,0)|| ' DAYS' AS interval)) AS due_date, bills.id, CONCAT(bills.sequence,' ', bills.folio), array_agg(orders.id)")
      render 'collection_report_extended'
    elsif params[:extended_collection_billing].present?
      @bills = Bill.uniq.joins(:store, :prospect).joins('LEFT JOIN payments ON payments.bill_id = bills.id LEFT JOIN orders ON orders.bill_id = bills.id').where("bills.store_id = #{@store_id}").where(created_at: @initial_date..@final_date, prospect_id: @prospect_id).order('bills.id').group('stores.store_name, prospects.legal_or_business_name, bills.bill_folio_type, bills.id, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, prospects.credit_days').pluck("stores.store_name, prospects.legal_or_business_name, bills.bill_folio_type, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, SUM(CASE WHEN payment_type = 'pago' THEN payments.total WHEN payment_type = 'devolución' THEN -payments.total ELSE 0 END), CONCAT(bills.sequence,' ', bills.folio), DATE_TRUNC('DAY', bills.created_at), (DATE_TRUNC('DAY', bills.created_at) + CAST(COALESCE(prospects.credit_days,0)|| ' DAYS' AS interval)) AS due_date, bills.id, CONCAT(bills.sequence,' ', bills.folio), array_agg(orders.id)")
      render 'collection_report_extended'
    else
      @bills = Bill.connection.select_all(@collection_consolidated_query).rows
      render 'collection_report'
    end
  end

  def prospect_types
    if params[:group_options] == 'Solo tiendas'
      @prospect_ids = Store.joins(:store_type, :store_prospect).where(store_types: {store_type: 'tienda propia'}).pluck('prospects.id')
      @prospect_names = Store.joins(:store_type, :store_prospect).where(store_types: {store_type: 'tienda propia'}).pluck('legal_or_business_name, store_types.store_type')
    elsif params[:group_options] == 'Solo franquicias'
      @prospect_ids = Store.joins(:store_type, :store_prospect).where(store_types: {store_type: 'franquicia'}).pluck('prospects.id')
      @prospect_names = Store.joins(:store_type, :store_prospect).where(store_types: {store_type: 'franquicia'}).pluck('legal_or_business_name, store_types.store_type')
    elsif params[:group_options] == 'Solo distribuidores'
      @prospect_ids = Prospect.joins(:store_type).where(store_types: {store_type: 'distribuidor'}).pluck(:id)
      @prospect_names = Prospect.joins(:store_type).where(store_types: {store_type: 'distribuidor'}).pluck('legal_or_business_name, store_types.store_type')
    elsif params[:group_options] == 'Franquicias y distribuidores'
      @prospect_ids = Prospect.joins(:store_type).where(store_types: {store_type: ['franquicia','distribuidor']}).pluck(:id)
      @prospect_names = Prospect.joins(:store_type).where(store_types: {store_type: ['franquicia','distribuidor']}).pluck('legal_or_business_name, store_types.store_type')
    else
      @prospect_ids = params[:client_list]
      @prospect_names = Prospect.joins(:store_type).where(id: params[:client_list]).pluck('legal_or_business_name, store_types.store_type')
    end
  end

  def monthly_report_stores
    prospect_types
    @first_year = Movement.where(movement_type: 'venta').first.created_at.year
    @fy = @first_year
    @current_year = Date.today.year
    @years = @current_year - @first_year
    initial_date = Date.parse(params[:month_and_year].join(',')).beginning_of_month.strftime('%F %H:%M:%S')
    final_date = Date.parse(params[:month_and_year].join(',')).end_of_month.strftime('%F 23:59:59')
    @date_selected = params[:month_and_year].join(',')
    @last_month_selected = (Date.parse(initial_date) - 1.month).strftime('%m/%Y')
    @last_year_selected = (Date.parse(initial_date) - 1.year).strftime('%m/%Y')
    month_before_initial = (initial_date.to_date - 1.month).strftime('%F %H:%M:%S')
    month_before_final = (final_date.to_date - 1.month).strftime('%F 23:59:59')
    year_before_initial = (initial_date.to_date - 1.year).strftime('%F %H:%M:%S')
    year_before_final = (final_date.to_date - 1.year).strftime('%F 23:59:59')

    month_sales = Movement.joins(:prospect).where(prospect_id: @prospect_ids).where("(movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}') OR (movements.created_at > '#{month_before_initial}' AND movements.created_at < '#{month_before_final}') OR (movements.created_at > '#{year_before_initial}' AND movements.created_at < '#{year_before_final}')").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END) as total, DATE_TRUNC('month', movements.created_at) AS month")

    #    @month_sales = Bill.joins(:prospect).where(prospect_id: @prospect_ids).where("(bills.created_at > '#{initial_date}' AND bills.created_at < '#{final_date}') OR (bills.created_at > '#{month_before_initial}' AND bills.created_at < '#{month_before_final}') OR (bills.created_at > '#{year_before_initial}' AND bills.created_at < '#{year_before_final}')").group("prospects.legal_or_business_name, DATE_TRUNC('month', bills.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -total WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN total ELSE 0 END) as total, DATE_TRUNC('month', bills.created_at) AS month")
    @month_sales = month_sales.each{ |arr| arr[2] = arr[2].strftime('%m/%Y')}.group_by{ |arr| arr[0]}

    this_month_sales = Prospect.joins('LEFT JOIN movements ON movements.prospect_id = prospects.id').where(id: @prospect_ids).where("movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}'").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END), 0) as total, DATE_TRUNC('month', movements.created_at) AS month")
    this_month_sales = this_month_sales.group_by{ |arr| arr[0]} if this_month_sales != []

    ly_month_sales = Prospect.joins('LEFT JOIN movements ON movements.prospect_id = prospects.id').where(id: @prospect_ids).where("movements.created_at > '#{year_before_initial}' AND movements.created_at < '#{year_before_final}'").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END), 0) as total, DATE_TRUNC('month', movements.created_at) AS month")
    ly_month_sales = ly_month_sales.group_by{ |arr| arr[0]} if ly_month_sales != []

    comparision = {}
    @prospect_names.each do |name|
      comparision[name[0]] = []
      if this_month_sales == [] || this_month_sales[name[0]] == [] || this_month_sales[name[0]] == nil
        comparision[name[0]] << 0
      else
        comparision[name[0]] << this_month_sales[name[0]][0][1].to_f
      end
      if ly_month_sales == [] || ly_month_sales[name[0]] == [] || ly_month_sales[name[0]] == nil
        comparision[name[0]] << 0
      else
        comparision[name[0]] << ly_month_sales[name[0]][0][1].to_f
      end
      comparision[name[0]] << name[1]
      if comparision[name[0]][0] > comparision[name[0]][1]
        status = 'sube'
        comparision[name[0]][1] == 0 ? percentage = 100 : percentage = ((comparision[name[0]][0] / comparision[name[0]][1]) - 1).round(1)
      elsif comparision[name[0]][0] < comparision[name[0]][1]
        status = 'baja'
        percentage = ((comparision[name[0]][0] / comparision[name[0]][1]) - 1).round(1)
      else
        status = 'sin info'
        percentage = 0
      end
      comparision[name[0]] << status
      comparision[name[0]] << percentage
      comparision[name[0]] << name[0]
    end
    @count_franchises = @prospect_names.select{ |arr| arr[1] == 'franquicia' }.length
    @count_distribuitors = @prospect_names.select{ |arr| arr[1] == 'distribuidor' }.length

    @up_franchise = comparision.values.select{ |arr| arr[3] == "sube" && arr[2] == 'franquicia'}.length
    @down_franchise = comparision.values.select{ |arr| arr[3] == "baja" && arr[2] == 'franquicia'}.length
    @no_info_franchise = comparision.values.select{ |arr| arr[3] == "sin info" && arr[2] == 'franquicia'}.length

    @up_distribuitor = comparision.values.select{ |arr| arr[3] == "sube" && arr[2] == 'distribuidor'}.length
    @down_distribuitor = comparision.values.select{ |arr| arr[3] == "baja" && arr[2] == 'distribuidor'}.length
    @no_info_distribuitor = comparision.values.select{ |arr| arr[3] == "sin info" && arr[2] == 'distribuidor'}.length

    @top_three_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort.reverse{ |arr| arr[0]}[0..2]

    @bottom_three_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort{ |arr| arr[0]}[0..2]

    @top_three_percentage_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort.reverse{ |arr| arr[4]}[0..2]

    @bottom_three_percentage_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort{ |arr| arr[4]}[0..2]

    render 'store_sales_comparision'
  end

  def sales_by_stores_summary
    params[:client_list] = params[:client_list].split('/')
    @prospect_ids = params[:client_list]
    @prospect_names = Prospect.joins(:store_type).where(id: @prospect_ids).pluck('legal_or_business_name, store_types.store_type')

    @first_year = Movement.where(movement_type: 'venta').first.created_at.year
    @fy = @first_year
    @current_year = Date.today.year
    @years = @current_year - @first_year
    initial_date = Date.parse(params[:date_selected]).beginning_of_month.strftime('%F %H:%M:%S')
    final_date = Date.parse(params[:date_selected]).end_of_month.strftime('%F 23:59:59')
    @date_selected = params[:date_selected]
    @last_month_selected = (Date.parse(initial_date) - 1.month).strftime('%m/%Y')
    @last_year_selected = (Date.parse(initial_date) - 1.year).strftime('%m/%Y')
    month_before_initial = (initial_date.to_date - 1.month).strftime('%F %H:%M:%S')
    month_before_final = (final_date.to_date - 1.month).strftime('%F 23:59:59')
    year_before_initial = (initial_date.to_date - 1.year).strftime('%F %H:%M:%S')
    year_before_final = (final_date.to_date - 1.year).strftime('%F 23:59:59')

    month_sales = Movement.joins(:prospect).where(prospect_id: @prospect_ids).where("(movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}') OR (movements.created_at > '#{month_before_initial}' AND movements.created_at < '#{month_before_final}') OR (movements.created_at > '#{year_before_initial}' AND movements.created_at < '#{year_before_final}')").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END) as total, DATE_TRUNC('month', movements.created_at) AS month")

    #    @month_sales = Bill.joins(:prospect).where(prospect_id: @prospect_ids).where("(bills.created_at > '#{initial_date}' AND bills.created_at < '#{final_date}') OR (bills.created_at > '#{month_before_initial}' AND bills.created_at < '#{month_before_final}') OR (bills.created_at > '#{year_before_initial}' AND bills.created_at < '#{year_before_final}')").group("prospects.legal_or_business_name, DATE_TRUNC('month', bills.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -total WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN total ELSE 0 END) as total, DATE_TRUNC('month', bills.created_at) AS month")
    @month_sales = month_sales.each{ |arr| arr[2] = arr[2].strftime('%m/%Y')}.group_by{ |arr| arr[0]}

    this_month_sales = Prospect.joins('LEFT JOIN movements ON movements.prospect_id = prospects.id').where(id: @prospect_ids).where("movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}'").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END), 0) as total, DATE_TRUNC('month', movements.created_at) AS month")
    this_month_sales = this_month_sales.group_by{ |arr| arr[0]} if this_month_sales != []

    ly_month_sales = Prospect.joins('LEFT JOIN movements ON movements.prospect_id = prospects.id').where(id: @prospect_ids).where("movements.created_at > '#{year_before_initial}' AND movements.created_at < '#{year_before_final}'").group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END), 0) as total, DATE_TRUNC('month', movements.created_at) AS month")
    ly_month_sales = ly_month_sales.group_by{ |arr| arr[0]} if ly_month_sales != []

    comparision = {}
    @prospect_names.each do |name|
      comparision[name[0]] = []
      if this_month_sales == [] || this_month_sales[name[0]] == [] || this_month_sales[name[0]] == nil
        comparision[name[0]] << 0
      else
        comparision[name[0]] << this_month_sales[name[0]][0][1].to_f
      end
      if ly_month_sales == [] || ly_month_sales[name[0]] == [] || ly_month_sales[name[0]] == nil
        comparision[name[0]] << 0
      else
        comparision[name[0]] << ly_month_sales[name[0]][0][1].to_f
      end
      comparision[name[0]] << name[1]
      if comparision[name[0]][0] > comparision[name[0]][1]
        status = 'sube'
        comparision[name[0]][1] == 0 ? percentage = 100 : percentage = ((comparision[name[0]][0] / comparision[name[0]][1]) - 1).round(1)
      elsif comparision[name[0]][0] < comparision[name[0]][1]
        status = 'baja'
        percentage = ((comparision[name[0]][0] / comparision[name[0]][1]) - 1).round(1)
      else
        status = 'sin info'
        percentage = 0
      end
      comparision[name[0]] << status
      comparision[name[0]] << percentage
      comparision[name[0]] << name[0]
    end
    @count_franchises = @prospect_names.select{ |arr| arr[1] == 'franquicia' }.length
    @count_distribuitors = @prospect_names.select{ |arr| arr[1] == 'distribuidor' }.length

    @up_franchise = comparision.values.select{ |arr| arr[3] == "sube" && arr[2] == 'franquicia'}.length
    @down_franchise = comparision.values.select{ |arr| arr[3] == "baja" && arr[2] == 'franquicia'}.length
    @no_info_franchise = comparision.values.select{ |arr| arr[3] == "sin info" && arr[2] == 'franquicia'}.length

    @up_distribuitor = comparision.values.select{ |arr| arr[3] == "sube" && arr[2] == 'distribuidor'}.length
    @down_distribuitor = comparision.values.select{ |arr| arr[3] == "baja" && arr[2] == 'distribuidor'}.length
    @no_info_distribuitor = comparision.values.select{ |arr| arr[3] == "sin info" && arr[2] == 'distribuidor'}.length

    @top_three_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort.reverse{ |arr| arr[0]}[0..2]

    @bottom_three_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort{ |arr| arr[0]}[0..2]

    @top_three_percentage_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort.reverse{ |arr| arr[4]}[0..2]

    @bottom_three_percentage_franchises = comparision.values.select{ |arr| arr[2] == 'franquicia'}.sort{ |arr| arr[4]}[0..2]
  end

  def stores_buying_report
    prospect_types
    @first_year = Movement.where(movement_type: 'venta').first.created_at.year
    @fy = @first_year
    @current_year = Date.today.year
    @years = @current_year - @first_year
    @month_sales = Movement.joins(:prospect).where(prospect_id: @prospect_ids).group("prospects.legal_or_business_name, DATE_TRUNC('month', movements.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.total WHEN movements.movement_type = 'venta' THEN movements.total ELSE 0 END) as total, DATE_TRUNC('month', movements.created_at) AS month")

#    @month_sales = Bill.joins(:prospect).where(prospect_id: @prospect_ids).group("prospects.legal_or_business_name, DATE_TRUNC('month', bills.created_at)").order('prospects.legal_or_business_name').pluck("prospects.legal_or_business_name, SUM(CASE WHEN bill_folio_type = 'Devolución' OR bill_folio_type = 'Nota de Crédito' THEN -total WHEN bill_folio_type = 'Factura' OR bill_folio_type = 'Nota de Débito' THEN total ELSE 0 END) as total, DATE_TRUNC('month', bills.created_at) AS month")

    if @month_sales != []
      grouped_values = {}
      @month_sales = @month_sales.group_by{|arr| arr[0]}.each{|k, v| v.each{ |a| a.delete_at(0); a[1] = a[1].strftime('%m/%Y') } }
      @month_sales.keys.each_with_index do |prospect, i|
        grouped_values = @month_sales.values[i].group_by{|arr| arr[1].partition('/').last.to_i}
        grouped_values.each do |key, value|
          val = [0,0,0,0,0,0,0,0,0,0,0,0]
          value.each do |arr|
            index = arr[1].partition('/').first.to_i - 1
            val[index] = arr[0]
          end
          grouped_values[key] = val
        end
        @month_sales[prospect] = grouped_values
      end
    else
      @month_sales = []
    end
    @month_names = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
    render 'stores_by_month_and_year'
  end

  def stores_by_month_and_year
  end

  def report_of_payment
    select_dates
    report_parameters
    @payments = Payment.joins(:payment_form, bill: [:prospect, :receiving_company, :issuing_company]).where("bills.issuing_company_id IN (#{@store_id})").where(ticket: nil, payment_date: @initial_date..@final_date)
    render 'payment_report'
  end

  def report_of_sales
    if params[:store_options] == 'Todas las tiendas'
      stores_id = Store.joins(:store_type).where(store_types: {store_type: 'tienda propia'}).pluck(:id)
    else
      stores_id = params[:store_list]
    end

    stores_id_string = stores_id.join(',')
    initial_date = Date.parse(params["month_and_year"].join(',')).beginning_of_month.strftime('%F %H:%M:%S')
    final_date = Date.parse(params["month_and_year"].join(',')).end_of_month.strftime('%F 23:59:59')

    month = initial_date.to_date.month
    year = initial_date.to_date.year
    @days = *(1..Time.days_in_month(month, year))
    @date = initial_date.to_date.strftime('%m/%Y')

    stores_query = "SELECT SUM(total) AS total, store_name, EXTRACT(day FROM day) AS day FROM (SELECT COALESCE(SUM (CASE WHEN movement_type = 'venta' THEN store_movements.total WHEN movement_type = 'devolución' THEN -store_movements.total ELSE 0 END ), 0) AS total, store_name, DATE_TRUNC('day', store_movements.created_at) AS day FROM store_movements LEFT JOIN stores ON store_movements.store_id = stores.id WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{stores_id_string}) AND store_movements.ticket_id IS NOT null GROUP BY store_name, day UNION ALL SELECT COALESCE(SUM (CASE WHEN service_type = 'venta' THEN service_offereds.total WHEN service_type = 'devolución' THEN -service_offereds.total ELSE 0 END ), 0) AS total, store_name, DATE_TRUNC('day', service_offereds.created_at) AS day FROM service_offereds LEFT JOIN stores ON service_offereds.store_id = stores.id WHERE service_offereds.created_at > '#{initial_date}' AND service_offereds.created_at < '#{final_date}' AND service_offereds.store_id IN (#{stores_id_string}) AND service_offereds.ticket_id IS NOT null GROUP BY store_name, day ORDER BY day) join_fields GROUP BY store_name, day ORDER BY store_name, day"

    @store_names = Store.where(id: stores_id).pluck(:store_name).sort
    @stores_and_bus = Store.joins(:business_unit).where(id: stores_id).pluck('stores.store_name', 'business_units.name').sort
    @stores = {}
    @big_totals = {}
    results = StoreMovement.connection.select_all(stores_query).rows

    results.each do |array|
      @days.each do |day|
        if @stores[day] == nil
          @stores[day] = {}
        else
          @store_names.each do |name|
            finded = results.select{ |arr| arr[2] == day.to_s && arr[1] == name }.flatten
            finded == [] ? @stores[day][name] = 0 : @stores[day][name] = finded[0].to_f
          end
        end
      end
    end
    @store_totals = results.group_by(&:second).map{ |k,v| [k, v.inject(0){ |sum, i| (sum + i.first.to_f).round(2) }] }
    @store_names.each_with_index do |name, index|
      @store_totals.insert(index, [name, 0]) unless @store_totals.select{ |arr| arr[0] == name } != []
    end
    @stores_and_bus.each_with_index do |arr, index|
      if @big_totals[arr[1]] == nil
        @big_totals[arr[1]] = @store_totals.select{ |a| a[0] == arr[0] }.flatten[1]
      else
        @big_totals[arr[1]] += @store_totals.select{ |a| a[0] == arr[0] }.flatten[1]
      end
    end
    @big_total = @big_totals.values.inject(0, :+)
    render 'show_sales'
  end

  def select_month_and_store
  end

  def show_sales
  end

  def select_report
    stores = Prospect.where(store_id: nil).order(:legal_or_business_name).pluck(:legal_or_business_name, :id)
    stores_id = current_user.store.business_unit.business_group.stores.joins(:store_type).where(store_types: {store_type: 'corporativo'}).pluck(:id)
    current_user.role.name == 'director' ? prospects = Prospect.where(store_id: stores_id).pluck(:legal_or_business_name, :id) : prospects = Prospect.where(store_id: current_user.store.id).pluck(:legal_or_business_name, :id)
    @client_list = stores + prospects
  end

  def show
    update_order_total
  end

  def update_order_total
    if params[:ids].present?
      @orders = Order.find(params[:ids].split('/'))
    elsif
      @orders != nil
      @orders = @orders
    else
      @orders = Order.where(id:params[:id])
    end
    @orders.each do |order|
      cost = 0
      subtotal = 0
      discount = 0
      taxes = 0
      total = 0
      if order.movements != []
        order.movements.each do |mov|
          if mov.quantity == nil
            mov.delete
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f
              subtotal += mov.subtotal.to_f
              discount += mov.discount_applied.to_f
              taxes += mov.taxes.to_f
              total += mov.total.to_f
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f
              subtotal -= mov.subtotal.to_f
              discount -= mov.discount_applied.to_f
              taxes -= mov.taxes.to_f
              total -= mov.total.to_f
            end
          end
        end
      end
      order.pending_movements.each do |mov|
        if mov.quantity == nil
          mov.delete
        else
          product = mov.product
          if product.group
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity * product.average
              subtotal += mov.subtotal.to_f * mov.quantity * product.average
              discount += mov.discount_applied.to_f * mov.quantity * product.average
              taxes += mov.taxes.to_f * mov.quantity * product.average
              total += (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity * product.average
              subtotal -= mov.subtotal.to_f * mov.quantity * product.average
              discount -= mov.discount_applied.to_f * mov.quantity * product.average
              taxes -= mov.taxes.to_f * mov.quantity * product.average
              total -= (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            end
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity
              subtotal += mov.subtotal.to_f * mov.quantity
              discount += mov.discount_applied.to_f * mov.quantity
              taxes += mov.taxes.to_f * mov.quantity
              total += (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity
              subtotal -= mov.subtotal.to_f * mov.quantity
              discount -= mov.discount_applied.to_f * mov.quantity
              taxes -= mov.taxes.to_f * mov.quantity
              total -= (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            end
          end
        end
      end
      subtotal = subtotal.round(2)
      discount = discount.round(2)
      taxes = taxes.round(2)
      cost = cost.round(2)
      total = total.round(2)
      order.update(
        subtotal: subtotal,
        discount_applied: discount,
        taxes: taxes,
        total: total,
        cost: cost
      )
    end
    orders_total = 0
    @orders.each do |order|
      orders_total += order.total
    end
    @orders_total = orders_total
  end

  def show_for_store
    update_order_total
    @order = Order.find(params[:id])
  end

  def show_for_differences
    update_order_total
    @order = Order.find(params[:id])
  end

  def solve_differences
    params[:id].each_with_index do |val, index|
      pr = ProductRequest.find(val)
      params[:solved][index] == 'true' ? solved = true : solved = false
      pr.update(solved: solved)
    end
    pr = ProductRequest.find(params[:id][0])
    redirect_to orders_differences_path, notice: "Se ha actualizado el pedido #{pr.order.id}"
  end

  def confirm_received
    order = Order.find(params[:order_id])
    if params[:order_complete] == 'true'
      order.update(status: 'entregado', deliver_complete: true, confirm_user: current_user)
      requests = order.product_requests.where.not(status: 'cancelada')
      requests.each do |request|
        request.update(status: 'entregado')
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov["cost"] = new_mov["cost"].to_f
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          if (current_user.store.id == 1 || current_user.store.id == 2)
            new_mov.delete("product_request_id")
            Movement.create(new_mov)
            if current_user.store.id == 1
              inventory = Inventory.where(product: mov.product).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            else
              inventory = StoresInventory.where(product: mov.product, store: mov.store).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            end
          else
            new_mov.delete("identifier")
            new_mov.delete("seller_user_id")
            new_mov.delete("buyer_user_id")
            new_mov.delete("business_unit_id")
            new_mov.delete("unique_code")
            new_mov.delete("entry_movement_id")
            new_mov.delete("discount_rule_id")
            new_mov.delete("confirm")
            new_mov.delete("maximum_date")
            new_mov.delete("return_billed")
            new_mov["web"] = true
            new_mov["pos"] = false
            new_mov["cost"] = new_mov["final_price"]
            if new_mov["kg"] != nil
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i * new_mov["kg"]
            else
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
            end
            new_mov.delete("kg")
            StoreMovement.create(new_mov)
          end
        end
      end
    else
      complete = true
      alert = ""
      surplus = params.keys.select.with_index{ |k| k.include?("surplus") && params[k] != '' }
      excess = params.keys.select.with_index{ |k| k.include?("excess") && params[k] != '' }
      complete_pr = params[:complete]
      complete_pr.each do |comp|
        request = ProductRequest.find(comp)
        request.update(status: 'entregado', quantity: request.quantity.to_i)
        counter = request.movements.count
        n = 0
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov["cost"] = new_mov["cost"].to_f
          new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          if counter == 1
            new_mov["quantity"] = new_mov["quantity"].to_i
          elsif counter != 1 && n == counter
            new_mov["quantity"] = new_mov["quantity"].to_i
          else
            new_mov["quantity"] = new_mov["quantity"].to_i
          end
          if (current_user.store.id == 1 || current_user.store.id == 2)
            new_mov.delete("product_request_id")
            Movement.create(new_mov)
            if current_user.store.id == 1
              inventory = Inventory.where(product: mov.product).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            else
              inventory = StoresInventory.where(product: mov.product, store: mov.store).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            end
          else
            new_mov.delete("identifier")
            new_mov.delete("seller_user_id")
            new_mov.delete("buyer_user_id")
            new_mov.delete("business_unit_id")
            new_mov.delete("unique_code")
            new_mov.delete("entry_movement_id")
            new_mov.delete("discount_rule_id")
            new_mov.delete("confirm")
            new_mov.delete("maximum_date")
            new_mov.delete("return_billed")
            new_mov["web"] = true
            new_mov["pos"] = false
            new_mov["cost"] = new_mov["final_price"]
            new_mov["total_cost"] = new_mov["cost"] * new_mov["quantity"].to_i
            if new_mov["kg"] != nil
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i * new_mov["kg"]
            else
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
            end
            new_mov.delete("kg")
            StoreMovement.create(new_mov)
          end
          n += 1
        end
      end
      surplus.each do |surp|
        pr_id = surp.partition("surplus_").last
        request = ProductRequest.find(pr_id)
        if params[surp] == ''
        else
          complete = false if params[surp].to_i != 0
          alert = "Faltan #{params[surp].to_i} piezas"
        end
        request.update(status: 'entregado', quantity: request.quantity.to_i - params[surp].to_i, alert: alert, excess: nil, surplus: params[surp].to_i)
        counter = request.movements.count
        n = 0
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov["cost"] = new_mov["cost"].to_f
          new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          if counter == 1
            new_mov["quantity"] = new_mov["quantity"].to_i - params[surp].to_i
          elsif counter != 1 && n == counter
            new_mov["quantity"] = new_mov["quantity"].to_i - params[surp].to_i
          else
            new_mov["quantity"] = new_mov["quantity"].to_i
          end
          if (current_user.store.id == 1 || current_user.store.id == 2)
            new_mov.delete("product_request_id")
            Movement.create(new_mov)
            if current_user.store.id == 1
              inventory = Inventory.where(product: mov.product).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            else
              inventory = StoresInventory.where(product: mov.product, store: mov.store).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            end
          else
            new_mov.delete("identifier")
            new_mov.delete("seller_user_id")
            new_mov.delete("buyer_user_id")
            new_mov.delete("business_unit_id")
            new_mov.delete("unique_code")
            new_mov.delete("entry_movement_id")
            new_mov.delete("discount_rule_id")
            new_mov.delete("confirm")
            new_mov.delete("maximum_date")
            new_mov.delete("return_billed")
            new_mov["web"] = true
            new_mov["pos"] = false
            new_mov["cost"] = new_mov["final_price"]
            new_mov["total_cost"] = new_mov["cost"] * new_mov["quantity"].to_i
            if new_mov["kg"] != nil
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i * new_mov["kg"]
            else
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
            end
            new_mov.delete("kg")
            StoreMovement.create(new_mov)
          end
          n += 1
        end
      end
      excess.each do |exces|
        pr_id = exces.partition("excess_").last
        request = ProductRequest.find(pr_id)
        if params[exces] == ''
        else
          complete = false if params[exces].to_i != 0
          alert = "Sobran #{params[exces].to_i} piezas"
        end
        request.update(status: 'entregado', quantity: request.quantity.to_i + params[exces].to_i, alert: alert, excess: params[exces].to_i, surplus: nil)

        counter = request.movements.count
        n = 0
        request.movements.each do |mov|
          new_mov = mov.as_json
          new_mov.delete("id")
          new_mov.delete("created_at")
          new_mov.delete("updated_at")
          new_mov["cost"] = new_mov["cost"].to_f
          new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
          new_mov["reason"] = "Pedido #{order.id}"
          new_mov["movement_type"] = 'alta automática'
          new_mov["store_id"] = current_user.store.id
          if counter == 1
            new_mov["quantity"] = new_mov["quantity"].to_i + params[exces].to_i
          elsif counter != 1 && n == counter
            new_mov["quantity"] = new_mov["quantity"].to_i + + params[exces].to_i
          else
            new_mov["quantity"] = new_mov["quantity"].to_i
          end
          if (current_user.store.id == 1 || current_user.store.id == 2)
            new_mov.delete("product_request_id")
            Movement.create(new_mov)
            if current_user.store.id == 1
              inventory = Inventory.where(product: mov.product).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            else
              inventory = StoresInventory.where(product: mov.product, store: mov.store).first
              inventory.update(quantity: inventory.quantity + mov.quantity)
            end
          else
            new_mov.delete("identifier")
            new_mov.delete("seller_user_id")
            new_mov.delete("buyer_user_id")
            new_mov.delete("business_unit_id")
            new_mov.delete("unique_code")
            new_mov.delete("entry_movement_id")
            new_mov.delete("discount_rule_id")
            new_mov.delete("confirm")
            new_mov.delete("maximum_date")
            new_mov.delete("return_billed")
            new_mov["web"] = true
            new_mov["pos"] = false
            new_mov["cost"] = new_mov["final_price"]
            new_mov["total_cost"] = new_mov["cost"] * new_mov["quantity"].to_i
            if new_mov["kg"] != nil
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i * new_mov["kg"]
            else
              new_mov["total_cost"] = new_mov["cost"].to_f * new_mov["quantity"].to_i
            end
            new_mov.delete("kg")
            StoreMovement.create(new_mov)
          end
          n += 1
        end
      end
      order.update(status: 'entregado', deliver_complete: complete, confirm_user: current_user)
    end
    redirect_to store_orders_path(current_user.store), notice: "El pedido #{order.id} ha sido confirmado como entregado"
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {
                    product: product,
                    images: product.images,
                    inventory: product.valid_inventory,
                   }
    else
      render json: {product: false}
    end
  end

  def _product_details
    @product = Product.find(params[:product])
  end

  def differences
    if ['store', 'store-admin'].include?(current_user.role.name)
      @orders = Order.uniq.joins(:product_requests).where('product_requests.excess IS NOT null OR product_requests.surplus IS NOT null').where('product_requests.solved != true').where(store: current_user.store, status: 'entregado')
    elsif ['admin-desk', 'warehouse-admin', 'warehouse-staff'].include?(current_user.role.name)
      @orders = Order.uniq.joins(:product_requests).where('product_requests.excess IS NOT null OR product_requests.surplus IS NOT null').where('product_requests.solved != true').where(corporate: current_user.store, status: 'entregado')
    else
      redirect_to root_path, alert: 'No cuenta con los permisos para ver esta pantalla'
    end
  end

  def differences_history
    if ['store', 'store-admin'].include?(current_user.role.name)
      @orders = Order.uniq.joins(:product_requests).where('product_requests.excess IS NOT null OR product_requests.surplus IS NOT null').where('product_requests.solved = true').where(store: current_user.store, status: 'entregado')
      orders = Order.uniq.joins(:product_requests).where('product_requests.excess IS NOT null OR product_requests.surplus IS NOT null').where('product_requests.solved = true').where(prospect: current_user.store.store_prospect, status: 'entregado')
      orders.each do |order|
        @orders << order
      end
    elsif ['admin-desk', 'warehouse-admin', 'warehouse-staff'].include?(current_user.role.name)
      @orders = Order.uniq.joins(:product_requests).where('product_requests.excess IS NOT null OR product_requests.surplus IS NOT null').where('product_requests.solved = true').where(corporate: current_user.store, status: 'entregado')
    else
      redirect_to root_path, alert: 'No cuenta con los permisos para ver esta pantalla'
    end
  end

  def delete_product_from_order
    # Este método funciona independientemente de si ya se facturó
    request = ProductRequest.find(params[:id])
    status = []
    if request.status != 'cancelada'
      product = request.product
      order = request.order
      @id = order.id
      total = order.total
      subtotal = order.subtotal
      taxes = order.taxes
      discount_applied = order.discount_applied
      order.movements.each do |mov|
        if mov.product == product
          if WarehouseEntry.where(product: product, store: order.corporate) != []
            number = WarehouseEntry.where(product: product, store: order.corporate).order(:id).last.entry_number.to_i
          else
            number = 0
          end
          entry_mov = mov.entry_movement
          if order.status != 'entregado'
            entry = WarehouseEntry.create(quantity: mov.quantity, product: mov.product, store: order.store, movement: entry_mov, entry_number: number.next)
            if order.corporate_id == 1
              inventory = Inventory.find_by_product_id(product.id)
            else
              inventory = StoresInventory.where(product: product, store: order.corporate_id).first
            end
            inventory.update(quantity: inventory.quantity + mov.quantity)
          end
          total -= mov.total
          subtotal -= mov.subtotal
          taxes -= mov.taxes
          discount_applied -= mov.discount_applied
          down_mov = mov.dup
          down_mov.update_attributes(
            movement_type: 'devolución'
          )
        end
      end
      order.pending_movements.each do |mov|
        if mov.product == product
          total -= mov.total
          subtotal -= mov.subtotal
          taxes -= mov.taxes
          discount_applied -= mov.discount_applied
          mov.delete
        end
      end
      request.update(status: 'cancelada')
      order.product_requests.each do |pr|
        status << pr.status
      end
    end
    order.update(status: 'mercancía asignada') if (status.uniq.length == 1 && status.first == 'asignado' && order.status == 'en espera')
    if order.product_requests.where.not(status: 'cancelada').count < 1
      order.update(status: 'cancelado')
      redirect_to root_path, notice: "Se canceló por completo el pedido #{order.id}."
    else
      order.update(total: total, subtotal: subtotal, taxes: taxes, discount_applied: discount_applied)
      redirect_to orders_show_for_store_path(order), notice: 'Se canceló este producto de su pedido.'
    end
  end

  def delete_product_requests(request)
    # Este método es casi igual al anterior pero acepta un parámetro (para cuando se eliminan toda la order), solo si no se ha procesado
    product = request.product
    order = request.order
    total = order.total
    subtotal = order.subtotal
    taxes = order.taxes
    discount_applied = order.discount_applied
    order.movements.each do |mov|
      # Falta el proceso que los quita de los reportes
      if mov.product == product
        if WarehouseEntry.where(product: product, store: order.corporate) != []
          number = WarehouseEntry.where(product: product, store: order.corporate).order(:id).last.entry_number.to_i
        else
          number = 0
        end
        entry_mov = mov.entry_movement
        if order.status != 'entregado'
          number = 0 if number == nil
          entry = WarehouseEntry.create(quantity: mov.quantity, product: mov.product, store: order.store, movement: entry_mov, entry_number: number.next)
          if order.corporate_id == 1
            inventory = Inventory.find_by_product_id(product.id)
          else
            inventory = StoresInventory.where(product: product, store: order.corporate_id).first
          end
          inventory.update(quantity: inventory.quantity + mov.quantity)
        end
        total -= mov.total
        subtotal -= mov.subtotal
        taxes -= mov.taxes
        discount_applied -= mov.discount_applied
        down_mov = mov.dup
        down_mov.update_attributes(
          movement_type: 'devolución'
        )
      end
    end
    order.pending_movements.each do |mov|
      total -= mov.total
      subtotal -= mov.subtotal
      taxes -= mov.taxes
      discount_applied -= mov.discount_applied
      mov.delete if mov.product == product
    end
    request.update(status: 'cancelada')
    if order.product_requests.where.not(status: 'cancelada').count < 1
      order.update(status: 'cancelado')
    else
      order.update(total: total, subtotal: subtotal, taxes: taxes, discount_applied: discount_applied)
    end
  end

  def delete_order
    # Este método es solo si no se ha facturado o procesado
    order = Order.find(params[:id])
    order.product_requests.each do |request|
      delete_product_requests(request)
    end
    orders_users = OrdersUser.find_by_order_id(order.id)
    orders_users.delete if orders_users != nil
    order.update(status: 'cancelado')
    redirect_to root_path, notice: "Se canceló por completo el pedido #{order.id}."
  end

  def save_products
    @store = Store.find(params[:store_id])
    @prospect = Prospect.find_by_store_prospect_id(current_user.store.id)
    corporate = Store.find(params[:corporate_store])
    @corporate = corporate
    status = []
    prod_req = []
    stores = []
    movs = []
    pend_movs = []
    @order = Order.create(
                  store: current_user.store,
                  request_user: current_user,
                  category: 'de línea',
                  corporate: corporate,
                  status: 'en espera',
                  delivery_address: current_user.store.delivery_address,
                  prospect: @prospect
                )
    @order.update(deliver_complete: true) if params[:deliver_complete] == "true" && @prospect.store_prospect_id != 2
    @order.users << current_user
    @order.save
    create_product_requests
    if @all_orders == nil
      @order = Order.last
      @order.product_requests.each do |pr|
        status << [pr.status]
        stores << pr.corporate_id
        prod_req << pr
      end
      if status.uniq.length != 1 || (status.uniq.length == 1 && stores.uniq.length != 1)
        if (!(@order.deliver_complete) || stores.uniq.length != 1)
          @order.movements.each do |mov|
            movs << mov
          end
          @order.pending_movements.each do |mov|
            pend_movs << mov
          end
          if status.uniq.length != 1 && params[:deliver_complete] != "true"
            @new_order = Order.create(
              store: current_user.store,
              request_user: current_user,
              category: 'de línea',
              corporate: corporate,
              delivery_address: current_user.store.delivery_address,
              status: 'en espera',
              prospect: @prospect
            )
          end
          assigned_mov_compresor = []
          assigned_mov_patria = []
          unassigned_pr_compresor = []
          unassigned_pr_patria = []
          assigned_pr_compresor = []
          assigned_pr_patria = []
          pendings_compresor = []
          pendings_patria = []
          prod_req.each do |pr|
            pend_movs.each do |pm|
              pendings_compresor << pm if (pm.product_id == pr.product_id && (pendings_compresor.include?(pm) == false) && pm.store_id == 1)
              pendings_patria << pm if (pm.product_id == pr.product_id && (pendings_patria.include?(pm) == false) && pm.store_id == 2)
              unassigned_pr_compresor << pr if (pm.product_id == pr.product_id && (unassigned_pr_compresor.include?(pr) == false) && pm.store_id == 1)
              unassigned_pr_patria << pr if (pm.product_id == pr.product_id && (unassigned_pr_patria.include?(pr) == false) && pm.store_id == 2)
            end
            movs.each do |mov|
              assigned_mov_compresor << mov if (pr.product_id == mov.product_id && (assigned_mov_compresor.include?(mov) == false) && mov.store_id == 1)
              assigned_mov_patria << mov if (pr.product_id == mov.product_id && (assigned_mov_patria.include?(mov) == false) && mov.store_id == 2)
              assigned_pr_compresor << pr if (pr.product_id == mov.product_id && (assigned_pr_compresor.include?(pr) == false) && mov.store_id == 1)
              assigned_pr_patria << pr if (pr.product_id == mov.product_id && (assigned_pr_patria.include?(pr) == false) && mov.store_id == 2)
            end
          end
          if params[:deliver_complete] == "true"
            pendings_patria != [] ? status = 'sin asignar' : status = 'mercancía asignada'
            @new_order_patria = Order.create(
              store: current_user.store,
              request_user: current_user,
              category: 'de línea',
              corporate_id: 2,
              delivery_address: current_user.store.delivery_address,
              status: status,
              prospect: @prospect
            )
            pendings_patria.each do |pend|
              PendingMovement.find(pend.id).update(order: @new_order_patria)
            end
            unassigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_patria)
            end
            assigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_patria)
            end
            assigned_mov_patria.each do |pr|
              Movement.find(pr.id).update(order: @new_order_patria)
            end
          else
            if pendings_patria != []
              @new_order_unassigned_patria = Order.create(
                store: current_user.store,
                request_user: current_user,
                category: 'de línea',
                corporate_id: 2,
                delivery_address: current_user.store.delivery_address,
                status: 'sin asignar',
                prospect: @prospect
              )
            end
            if assigned_mov_patria != []
              @new_order_assigned_patria = Order.create(
                store: current_user.store,
                request_user: current_user,
                category: 'de línea',
                corporate_id: 2,
                delivery_address: current_user.store.delivery_address,
                status: 'mercancía asignada',
                prospect: @prospect
              )
            end
            pendings_patria.each do |pend|
              PendingMovement.find(pend.id).update(order: @new_order_unassigned_patria)
            end
            unassigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_unassigned_patria)
            end
            assigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_assigned_patria)
            end
            assigned_mov_patria.each do |pr|
              Movement.find(pr.id).update(order: @new_order_assigned_patria)
            end
          end
          params[:deliver_complete] == "true" ? order_compresor = @order : order_compresor = @new_order
          pendings_compresor.each do |pend|
            PendingMovement.find(pend.id).update(order: order_compresor)
          end
          unassigned_pr_compresor.each do |pr|
            ProductRequest.find(pr.id).update(order: order_compresor)
          end
        else
          @order.update(status: 'en espera')
        end
      else
        if status.first == ['asignado']
          @order.update(status: 'mercancía asignada')
        end
      end
      @orders = []
      @orders << @order.id
      @orders << @new_order.id unless @new_order == nil
      @orders << @new_order_assigned_patria.id unless @new_order_assigned_patria == nil
      @orders << @new_order_unassigned_patria.id unless @new_order_unassigned_patria == nil
      @orders << @new_order_patria.id unless @new_order_patria == nil
      @orders.each do |order|
        order = Order.find(order)
        order.product_requests.pluck(:status).uniq.length == 1 && order.product_requests.pluck(:status).uniq == ["asignado"] ? order.update(status: 'mercancía asignada') : order.update(status: 'en espera')
      end
      redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
    else
      @orders = []
      @all_orders.each do |order|
        if order.pending_movements == []
          order.update(status: 'mercancía asignada')
        end
        @orders << order.id
      end
      @orders.each do |order|
        order = Order.find(order)
        order.product_requests.pluck(:status).uniq.length == 1 && order.product_requests.pluck(:status).uniq == ["asignado"] ? order.update(status: 'mercancía asignada') : order.update(status: 'en espera')
      end
      redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
    end
  end

  def save_products_for_prospects
    @prospect = Prospect.find(params[:prospect_id])
    corporate = Store.joins(:store_type).where(store_types: {store_type: 'corporativo'}).first
    @corporate = corporate
    status = []
    prod_req = []
    stores = []
    movs = []
    pend_movs = []
    prod_arr = Product.where(id: params[:products]).pluck(:classification)
    (prod_arr.first == 'especial' && prod_arr.uniq.length == 1) ? @category = 'especial' : @category = 'de línea'
    if @category == 'especial' && current_user.store.id == 2
      @corporate = Store.find(current_user.store.id)
      corporate = @corporate
    end
    @order = Order.create(
                  store: current_user.store,
                  request_user: current_user,
                  corporate: corporate,
                  category: @category,
                  status: 'en espera',
                  delivery_address: current_user.store.delivery_address,
                  prospect: @prospect
                )
    @order = Order.last
    @order.update(deliver_complete: true) if params[:deliver_complete] == "true"
    @order.users << current_user
    @order.save
    create_product_requests
    if @all_orders == nil
      @order = Order.last
      @order.product_requests.each do |pr|
        status << [pr.status]
        stores << pr.corporate_id
        prod_req << pr
      end
      if status.uniq.length != 1 || (status.uniq.length == 1 && stores.uniq.length != 1)
        if (!(@order.deliver_complete) || stores.uniq.length != 1)
          @order.movements.each do |mov|
            movs << mov
          end
          @order.pending_movements.each do |mov|
            pend_movs << mov
          end
          if status.uniq.length != 1 && params[:deliver_complete] != "true"
            @new_order = Order.create(
              store: current_user.store,
              request_user: current_user,
              category: @category,
              corporate: corporate,
              delivery_address: current_user.store.delivery_address,
              status: 'en espera',
              prospect: @prospect
            )
          end
          assigned_mov_compresor = []
          assigned_mov_patria = []
          unassigned_pr_compresor = []
          unassigned_pr_patria = []
          assigned_pr_compresor = []
          assigned_pr_patria = []
          pendings_compresor = []
          pendings_patria = []
          prod_req.each do |pr|
            pend_movs.each do |pm|
              pendings_compresor << pm if (pm.product_id == pr.product_id && (pendings_compresor.include?(pm) == false) && pm.store_id == 1)
              pendings_patria << pm if (pm.product_id == pr.product_id && (pendings_patria.include?(pm) == false) && pm.store_id == 2)
              unassigned_pr_compresor << pr if (pm.product_id == pr.product_id && (unassigned_pr_compresor.include?(pr) == false) && pm.store_id == 1)
              unassigned_pr_patria << pr if (pm.product_id == pr.product_id && (unassigned_pr_patria.include?(pr) == false) && pm.store_id == 2)
            end
            movs.each do |mov|
              assigned_mov_compresor << mov if (pr.product_id == mov.product_id && (assigned_mov_compresor.include?(mov) == false) && mov.store_id == 1)
              assigned_mov_patria << mov if (pr.product_id == mov.product_id && (assigned_mov_patria.include?(mov) == false) && mov.store_id == 2)
              assigned_pr_compresor << pr if (pr.product_id == mov.product_id && (assigned_pr_compresor.include?(pr) == false) && mov.store_id == 1)
              assigned_pr_patria << pr if (pr.product_id == mov.product_id && (assigned_pr_patria.include?(pr) == false) && mov.store_id == 2)
            end
          end
          if params[:deliver_complete] == "true"
            pendings_patria != [] ? status = 'sin asignar' : status = 'mercancía asignada'
            @new_order_patria = Order.create(
              store: current_user.store,
              request_user: current_user,
              category: @category,
              corporate_id: 2,
              delivery_address: current_user.store.delivery_address,
              status: status,
              prospect: @prospect
            )
            pendings_patria.each do |pend|
              PendingMovement.find(pend.id).update(order: @new_order_patria)
            end
            unassigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_patria)
            end
            assigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_patria)
            end
            assigned_mov_patria.each do |pr|
              Movement.find(pr.id).update(order: @new_order_patria)
            end
          else
            if pendings_patria != []
              @new_order_unassigned_patria = Order.create(
                store: current_user.store,
                request_user: current_user,
                category: @category,
                corporate_id: 2,
                delivery_address: current_user.store.delivery_address,
                status: 'sin asignar',
                prospect: @prospect
              )
            end
            if assigned_mov_patria != []
              @new_order_assigned_patria = Order.create(
                store: current_user.store,
                request_user: current_user,
                category: @category,
                corporate_id: 2,
                delivery_address: current_user.store.delivery_address,
                status: 'mercancía asignada',
                prospect: @prospect
              )
            end
            pendings_patria.each do |pend|
              PendingMovement.find(pend.id).update(order: @new_order_unassigned_patria)
            end
            unassigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_unassigned_patria)
            end
            assigned_pr_patria.each do |pr|
              ProductRequest.find(pr.id).update(order: @new_order_assigned_patria)
            end
            assigned_mov_patria.each do |pr|
              Movement.find(pr.id).update(order: @new_order_assigned_patria)
            end
          end
          params[:deliver_complete] == "true" ? order_compresor = @order : order_compresor = @new_order
          pendings_compresor.each do |pend|
            PendingMovement.find(pend.id).update(order: order_compresor)
          end
          unassigned_pr_compresor.each do |pr|
            ProductRequest.find(pr.id).update(order: order_compresor)
          end
        else
          @order.update(status: 'en espera')
        end
      else
        if status.first == ['asignado']
          @order.update(status: 'mercancía asignada')
        end
      end
      @orders = []
      @orders << @order.id
      @orders << @new_order.id unless @new_order == nil
      @orders << @new_order_assigned_patria.id unless @new_order_assigned_patria == nil
      @orders << @new_order_unassigned_patria.id unless @new_order_unassigned_patria == nil
      @orders << @new_order_patria.id unless @new_order_patria == nil
      @orders.each do |order|
        order = Order.find(order)
        order.product_requests.pluck(:status).uniq.length == 1 && order.product_requests.pluck(:status).uniq == ["asignado"] ? order.update(status: 'mercancía asignada') : order.update(status: 'en espera')
      end
      redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
    else
      @orders = []
      @all_orders.each do |order|
        if order.pending_movements == []
          order.update(status: 'mercancía asignada')
        end
        @orders << order.id
      end
      @orders.each do |order|
        order = Order.find(order)
        order.product_requests.pluck(:status).uniq.length == 1 && order.product_requests.pluck(:status).uniq == ["asignado"] ? order.update(status: 'mercancía asignada') : order.update(status: 'en espera')
      end
      redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
    end
  end

  def confirm
    @orders = Order.find(params[:ids].split('/'))
    @orders.each do |order|
      order.movements.each do |mov|
        mov.update(confirm: true)
      end
      order.update(confirm: true)
    end
    redirect_to store_orders_path(@orders.first.store), notice: 'Registros confirmados'
  end

  def change_delivery_address
    delivery = params[:order][:delivery_address]
    address = DeliveryAddress.find(delivery) unless (delivery == 'otra dirección' || delivery == 'seleccione' || delivery == '')
    notes = params[:order][:delivery_notes] unless address.present?
    if (address == nil && notes.blank?)
      redirect_to show_for_store, notice: 'Por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
    else
      if address.nil?
        @order.delivery_address = nil
      else
        @order.delivery_address = address
      end
      @order.delivery_notes = notes unless notes.nil?
      if @order.save
        redirect_to store_orders_path(current_user.store), notice: 'La dirección se actualizó correctamente.'
      else
        redirect_to show_for_store, notice: 'Hubo un error, por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
      end
    end
  end

  def index
    current_orders
    debugger
  end

  def current_orders
    permited_roles_corp = ['warehouse-staff', 'warehouse-admin', 'admin-desk']
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(store: current_user.store).order(:created_at)
      my_status = ['entregado', 'cancelado', 'expirado']
      add_orders(my_status, false)
    elsif (permited_roles_corp.include?(current_user.role.name) && current_user.store.id == 1)
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(store: current_user.store, corporate_id: 2).order(:created_at)
    elsif current_user.role.name == 'viewer'
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).order(:created_at)
    else
      @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(corporate: current_user.store).order(:created_at)
    end
    @orders
  end

  def add_orders(status, type)
    if type
      orders = Order.where(prospect: current_user.store.store_prospect, status: status)
    else
      orders = Order.where(prospect: current_user.store.store_prospect).where.not(status: status)
    end
    debugger
    orders.each do |order|
      @orders << order unless @orders.include?(order)
    end
    debugger
  end

  def for_delivery
    @orders = Order.where.not(status: ['entregado', 'cancelado', 'expirado']).where(corporate: current_user.store).order(:created_at)
  end

  def delivered_orders
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where(status:'entregado', store: current_user.store).order(:created_at)
      my_status = 'entregado'
      add_orders(my_status, true)
    elsif current_user.role.name == 'viewer'
      @orders = Order.where(status:'entregado').order(:created_at)
    else
      @orders = Order.where(status:'entregado', corporate: current_user.store).order(:created_at)
    end
  end

  def history
    delivered_orders
  end

  def cancelled
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @orders = Order.where(store: current_user.store, status: 'cancelado')
      my_status = 'cancelado'
      add_orders(my_status, true)
    else
      @orders = Order.where(status: 'cancelado', corporate: current_user.store)
    end
  end

  private

  def create_product_requests
    counter = params[:products].count
    n = 0
    converted_armed = false
    if params[:armed][n] == 'true'
      converted_armed = true
    end
    if @prospect.store_prospect != nil && @prospect.store_prospect.id == 1
      @all_orders = []
      counter.times do
        product = Product.find(params[:products][n])
        if n == 0
          product_request = ProductRequest.create(
            product: product,
            status: 'asignado',
            quantity: params[:request][n],
            corporate: @corporate,
            armed: converted_armed,
            order: @order
          )
          @all_orders << @order
        else
          @order = @order.dup
          @order.save
          @all_orders << @order
          product_request = ProductRequest.create(
            product: product,
            status: 'asignado',
            quantity: params[:request][n],
            corporate: @corporate,
            armed: converted_armed,
            order: @order
          )
        end
        if product_request.save
          passing_validation(product_request, n)
        end
        n += 1
      end
    else
      counter.times do
        product = Product.find(params[:products][n])
        product_request = ProductRequest.create(
          product: product,
          status: 'asignado',
          quantity: params[:request][n],
          corporate: @corporate,
          armed: converted_armed,
          order: @order
        )
        if product_request.save
          passing_validation(product_request, n)
        end
        n += 1
      end
    end
  end

  def passing_validation(product_request, n)
    order_quantity = product_request.quantity
    @corporate = product_request.product.business_unit.stores.where(store_type_id: 2).first if @category == 'especial'
    corporate = @corporate
    if @corporate.id == 1
      inventory = product_request.product.inventory
      inventory_patria = StoresInventory.where(product: product_request.product, store_id: 2).first
      if (order_quantity > inventory.quantity && order_quantity <= inventory_patria.quantity && product_request.product.business_unit_id == 1)
        inventory = inventory_patria
        corporate = Store.find(2)
        product_request.update(corporate: corporate)
      end
    else
      inventory = StoresInventory.where(product: product_request.product, store_id: 2).first
    end
    product = product_request.product
    if params[:discount] != nil
      discount = params[:discount][n].to_f / 100
    else
      if @prospect.store_prospect != nil && @prospect.store_prospect.id != 1
        if (product.armed && params[:armed][n] == 'true')
          discount = product.armed_discount / 100
        else
          if (@prospect.store_prospect.store_type.store_type == 'tienda propia')
            discount = @prospect.discount / 100
          elsif @prospect.store_prospect.store_type.store_type == 'franquicia'
            discount = @prospect.discount / 100
          end
        end
      else
        if params[:discount] != nil
          discount = params[:discount][n].to_f / 100
        else
          if @prospect.store_prospect.store_type.store_type == 'corporativo'
            discount = @prospect.discount.to_f / 100
          end
        end
      end
    end

    if order_quantity > inventory.quantity
      product_request.update(status: 'sin asignar')
      q = product_request.quantity
      mov = create_movement(PendingMovement, n, product_request, corporate)
    else
      q = product_request.quantity
      if product.group && q > 1
        multiple = q
        q.times do
          Movement.new_object(
            product_request,
            current_user,
            'venta',
            discount,
            @prospect,
            corporate,
            multiple
            )
        end
        # Revisar que hacer cuando haya un request de más de 1 rollo y este separarlo por cada uno y ver los pendings
      else
        Movement.new_object(
          product_request,
          current_user,
          'venta',
          discount,
          @prospect,
          corporate,
          multiple
          )
      end
    end
  end

  def create_movement(object, n, product_request, corporate)
    product = product_request.product
    store = Store.find_by_store_name(corporate.store_name)
    prospect = @prospect
    if prospect.store_prospect != nil && prospect.store_prospect.id != 1
      if (product.armed && params[:armed][n] == 'true')
        discount = product.armed_discount / 100
      else
        if (prospect.store_prospect.store_type.store_type == 'tienda propia')
          discount = product.discount_for_stores / 100
        elsif prospect.store_prospect.store_type.store_type == 'franquicia'
          discount = product.discount_for_franchises / 100
        end
      end
    else
      if params[:discount] != nil
        discount = params[:discount][n].to_f / 100
      else
        if prospect.store_prospect.store_type.store_type == 'corporativo'
          discount = prospect.discount.to_f / 100
        end
      end
    end
    price = ('%.2f' % product.price).to_f
    disc_app = ('%.2f' % (product.price * discount)).to_f
    unit_price = ('%.2f' % (price * (1 - discount))).to_f
    cost = ('%.2f' % product.cost.to_f).to_f
    movement = object.create(
      product: product,
      order: @order,
      unique_code: product.unique_code,
      quantity: product_request.quantity,
      store: store,
      initial_price: price,
      automatic_discount: disc_app,
      discount_applied: disc_app,
      supplier: product.supplier,
      final_price: unit_price,
      movement_type: 'venta',
      user: current_user,
      cost: cost,
      total: unit_price * 1.16,
      taxes: unit_price * 0.16,
      subtotal: product.price,
      business_unit: store.business_unit,
      product_request: product_request,
      maximum_date: product_request.maximum_date,
      prospect: prospect
    )
    movement
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
