class BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bill, only: [:show, :edit, :bill, :bill_doc, :update, :destroy, :download_pdf, :download_xml, :download_xml_receipt]

  require 'rqrcode'
  require 'savon'
  require 'base64'

  def index
    if current_user.role.name == 'viewer'
      @bills = Bill.includes(:receiving_company, :children, :prospect).joins('LEFT JOIN payments ON payments.bill_id = bills.id').where(store: current_user.store, bill_folio_type: ['Factura', 'Sustitución'], from: 'Form').where.not(status: 'cancelada', receiving_company: nil, total: nil).where(relation_type_id: [nil, 4]).uniq
    else
      @bills = Bill.includes(:receiving_company, :children, :prospect).joins('LEFT JOIN payments ON payments.bill_id = bills.id').where(store: current_user.store, bill_folio_type: ['Factura', 'Sustitución']).where.not(status: 'cancelada', receiving_company: nil, total: nil).where(relation_type_id: [nil, 4]).uniq
    end
  end

  def pending
    if ['store', 'store-admin'].include?(current_user.role.name)
      @bills = Bill.includes(:payments, :receiving_company, :children, :prospect).where(prospect: current_user.store.store_prospect, payed: false, bill_folio_type: ["Factura", "Sustitución"]).where.not(status: 'cancelada', receiving_company: nil, total: nil).where(relation_type_id: [nil, 4]).uniq
    else
      @bills = Bill.includes(:payments, :receiving_company, :children, :prospect).where(store: current_user.store, payed: false, bill_folio_type: ["Factura", "Sustitución"]).where.not(status: 'cancelada', receiving_company: nil, total: nil).where(relation_type_id: [nil, 4]).uniq
    end
    Bill.where.not(bill_folio_type: ["Factura", "Sustitución", "Pago"]).find_each do |bill|
      validate_payed(bill.parent)
    end
  end

  def get_document
    document = Document.find(params[:id])
    redirect_to document.document_url
  end

  def confirm_payments
    params[:id].each_with_index do |val, i|
      bill = Bill.find(val)
      unless params[:payments][i].to_f == 0
        pn = bill.payments.count + 1
        pay = Payment.create(payment_type: 'pago', total: params[:payments][i].to_f, payment_number: pn, payment_form_id: params[:payment_form].to_i, payment_date: Date.parse(params[:date]), date: Date.today, bill: bill, user: current_user)
        validate_payed(bill)
        orders = bill.orders
        orders.each do |order|
          order.payments << pay
        end
        Document.create(document_type: 'pago', bill: bill, document: params[:image])
      end
    end
    redirect_to bills_pending_path, notice: 'Su pago ha sido registrado'
  end

  def validate_payed(bill)
    total_pay = bill.payments.where(payment_type: 'pago').sum(:total) - bill.payments.where(payment_type: 'devolución').sum(:total)
    total_bill = bill.total - bill.children.where.not(status: 'cancelada').sum(:total)
    (total_bill - total_pay < 1) ? bill.update(payed: true) : bill.update(payed: false)
  end

  def show
  end

  def download_pdf
    redirect_to @bill.pdf_url
  end

  def download_xml
    redirect_to @bill.xml_url
  end

  def download_xml_receipt
    redirect_to @bill.cancel_receipt_url
  end

  def filter_tickets
  end

  def modify
    @bill = Bill.find(params[:bill])
    # Revisar bien cómo haré el proceso para incluir (Dev Pag NC ND Sust Canc)
  end

  def payment
    @bill = Bill.find(params[:bill])
  end

  def credit_note
    @bill = Bill.find(params[:bill])
  end

  def credit_note_global
    @bill = Bill.find(params[:bill])
  end

  def debit_note
    @bill = Bill.find(params[:bill])
  end

  def devolution
    @bill = Bill.find(params[:bill])
  end

  def devolution_global
    @bill = Bill.find(params[:bill])
  end

  def advance_e
    @bill = Bill.find(params[:bill])
  end

  def advance_i
    @bill = Bill.find(params[:bill])
  end

  def cancelled
    @bills = current_user.store.bills.where(status: 'cancelada')
  end

  def generate_credit_note
  end

  def generate_debit_note
  end

  def generate_devolution
  end

  def generate_payment
  end

  def generate_advance_e
  end

  def generate_advance_i
  end

  def details
    @bill = Bill.find(params[:bill])
    payments_for_bill_show
  end

  def details_global
    @bill = Bill.find(params[:bill])
    payments_for_bill_show
  end

  def select_action
  end

  def issued
    store = Store.find(params[:store]) || current_user.store
    month = params[:month]
    year = params[:year]
    @bills = store.bills.where('extract(month from created_at) = ? and extract(year from created_at) = ?', month, year).where(relation_type_id: [nil, 4]).where.not(pdf: nil, xml: nil, status: 'cancelada')
  end

  def select_bills
    store = current_user.store
    @bills = store.bills.where.not(status: 'cancelada').where.not(receiving_company: nil).where.not(total: nil).where(parent: nil)
  end

  def payments_for_bill_show
    @payments_bill = []
    @total_payments_bill = 0
    @bill.payments.each do |payment|
      unless payment.payment_type == 'crédito'
        @payments_bill << payment
        if payment.payment_type == 'pago'
          @total_payments_bill += payment.total
        elsif payment.payment_type == 'devolución'
          @total_payments_bill -= payment.total
        end
      end
    end
    @total_payments_bill
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
    total = 0
    @payments_ticket.each do |pay|
      if pay.payment_type = 'pago'
        total += pay.total
      elsif pay.payment_type = 'devolución'
        total -= pay.total
      end
    end
    @total_payments_ticket = total.round(2)
    @total_payments_ticket
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

  def billed_tickets
    store = current_user.store
    @tickets = store.tickets.where(parent:nil).where.not(bill: nil)
  end

  def select_store(user = current_user)
    @series = []
    @folio = []
    @user = user
    @role = @user.role.name
    @zipcodes = []
    # Este método es solo para los formularios en Bills
    if (@role == 'store' || @role == 'store-admin')
      store = current_user.store
      @store = store
      @series << [store.series, store.id]
      @folio << [store.bill_last_folio.next, store.id]
      @folio << [store.credit_note_last_folio.next, store.id]
      @folio << [store.debit_note_last_folio.next, store.id]
      @folio << [store.pay_bill_last_folio.next, store.id]
      @folio << [store.advance_e_last_folio.next, store.id]
      @folio << [store.advance_i_last_folio.next, store.id]
      @zipcodes << [store.business_unit.billing_address.zipcode, store.id]
    else
      @stores = Store.joins(:store_type).where(store_types: {store_type: 'corporativo'})
      @stores.each do |store|
        @series << [store.series, store.id]
        @folio << [store.bill_last_folio.next, store.id]
        @folio << [store.credit_note_last_folio.next, store.id]
        @folio << [store.debit_note_last_folio.next, store.id]
        @folio << [store.pay_bill_last_folio.next, store.id]
        @folio << [store.advance_e_last_folio.next, store.id]
        @folio << [store.advance_i_last_folio.next, store.id]
        @zipcodes << [store.business_unit.billing_address.zipcode, store.id]
      end
    end
  end

  def select_type_of_bill
    if params[:type_of_bill] == nil
      type_of_bill = TypeOfBill.find_by_key('I')
    else
      type_of_bill = TypeOfBill.find(params[:type_of_bill])
    end
    @bill_type = type_of_bill
    @type_of_bill_key = type_of_bill.key
    @type_of_bill = type_of_bill.description
  end

  def select_stores_info
    @store_series = [['seleccione']]
    @store_folio = [['seleccione']]
    @store_zipcodes = [['seleccione']]
    @store_legal_names = [['seleccione']]
    @store_rfcs = [['seleccione']]
    @store_tax_regimes = [['seleccione']]
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      store = @store
      billing = store.business_unit.billing_address
      @store_series << [store.series, store.id]
      @store_folio << [store.bill_last_folio.to_i.next, store.id]
      @store_zipcodes << [store.zip_code, store.id]
      @store_legal_names << [billing.business_name, store.id]
      @store_rfcs << [billing.rfc, store.id]
      regime_string = billing.tax_regime.tax_id.to_s + ' - ' + billing.tax_regime.description.to_s
      @store_tax_regimes << [regime_string, store.id]
    else
      @stores.each do |store|
        billing = store.business_unit.billing_address
        @store_series << [store.series, store.id]
        @store_folio << [store.bill_last_folio.to_i.next, store.id]
        @store_zipcodes << [store.zip_code, store.id]
        @store_legal_names << [billing.business_name, store.id]
        @store_rfcs << [billing.rfc, store.id]
        regime_string = billing.tax_regime.tax_id.to_s + ' - ' + billing.tax_regime.description.to_s
        @store_tax_regimes << [regime_string, store.id]
      end
    end
  end

  def select_prospects_info
    @prospects_names = [['seleccione']]
    @prospects_rfcs = [['seleccione']]
    if (@user.role.name == 'store' || @user.role.name == 'store-admin')
      prospects = @store.prospects.where.not(billing_address: nil)
    else
      prospects = Prospect.joins(:billing_address).joins(:business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
    prospects.each do |prospect|
      if prospect.billing_address != nil
        unless prospect.legal_or_business_name == 'Público en General'
          @prospects_names << [prospect.billing_address.business_name, prospect.id]
          @prospects_rfcs << [prospect.billing_address.rfc, prospect.id]
        end
      end
    end
  end

  def select_general_prospect_info
    @prospects_names = [['seleccione']]
    @prospects_rfcs = [['seleccione']]

    if (@user.role.name == 'store' || @user.role.name == 'store-admin')
      global = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first

      foreign =  Prospect.where(legal_or_business_name: 'Residente en el extranjero', direct_phone: 1111111111, prospect_type: 'residente en el extranjero', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
      @prospects_rfcs << [global.billing_address.rfc, global.id]
      @prospects_names << [global.billing_address.business_name, global.id]
      @prospects_rfcs << [foreign.billing_address.rfc, foreign.id]
      @prospects_names << [foreign.billing_address.business_name, foreign.id]
    else
      global_1 = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @stores.first).first

      global_2 = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @stores.second).first

      foreign_1 =  Prospect.where(legal_or_business_name: 'Residente en el extranjero', direct_phone: 1111111111, prospect_type: 'residente en el extranjero', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @stores.first).first

      foreign_2 =  Prospect.where(legal_or_business_name: 'Residente en el extranjero', direct_phone: 1111111111, prospect_type: 'residente en el extranjero', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @stores.second).first
      @prospects_rfcs << [global_1.billing_address.rfc, global_1.id]
      @prospects_rfcs << [global_2.billing_address.rfc, global_2.id]
      @prospects_names << [global_1.billing_address.business_name, global_1.id]
      @prospects_names << [global_2.billing_address.business_name, global_2.id]

      @prospects_rfcs << [foreign_1.billing_address.rfc, foreign_1.id]
      @prospects_rfcs << [foreign_2.billing_address.rfc, foreign_2.id]
      @prospects_names << [foreign_1.billing_address.business_name, foreign_1.id]
      @prospects_names << [foreign_2.billing_address.business_name, foreign_2.id]
    end
  end

  def select_payment_forms
    @payment_forms = [['seleccione']]
    PaymentForm.find_each do |pf|
      string = pf.payment_key + ' - ' + pf.description
      @payment_forms << [string, pf.id]
    end
    @global_payment_form = PaymentForm.find_by_description('Por definir').id
  end

  def select_payment_conditions
    @payment_conditions = [['seleccione'], ['Contado'], ['Crédito']]
  end

  def select_payment_methods
    @payment_methods = [['seleccione']]
    PaymentMethod.find_each do |pm|
      string = pm.method + ' - ' + pm.description
      @payment_methods << [string, pm.id]
    end
     @global_method = PaymentMethod.find_by_method('PUE').id
  end

  def select_cfdi_use
    @cfdi_use = [['seleccione']]
    CfdiUse.find_each do |use|
      cfdi_string = use.key + ' - ' + use.description
      @cfdi_use << [cfdi_string, use.id]
    end
    @cfdi_global = CfdiUse.find_by_description('Por definir').id
  end

  def get_time
      @time = Time.now.strftime('%FT%T')
  end

  def get_info_for_form
    select_store
    select_stores_info
    select_payment_forms
    select_payment_conditions
    select_payment_methods
    select_cfdi_use
    get_time
  end

  def filter_product_options
    @products_ids = []
    @products_codes = []
    @products_description = []
    @products_sat_keys = []
    @products_sat_unit_keys = []
    @products_units = []
    @products_prices = []
    @byll_types = []
    TypeOfBill.find_each do |tb|
      string = tb.key + ' ' + '-' + tb.description
      @byll_types << [string, tb.id]
    end
    @products = Product.where(classification: 'de línea').where(current: true)
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @store_products = Product.where(store: current_user.store)
    end
    if @store_products != nil
      @store_products.each do |product|
        @products << product
      end
    end
    services = Service.where(current: true)
    @products.each do |product|
      @products_ids << [product.id]
      @products_codes << [product.unique_code, product.id]
      @products_description << [product.description, product.id]
      @products_sat_keys << [product.sat_key.sat_key, product.id]
      @products_sat_unit_keys << [product.sat_unit_key.unit, product.id]
      @products_units << [product.sat_unit_key.description, product.id]
      if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
        @products_prices << [(product.price * (1 + (@store.overprice.to_f / 100))).round(2), product.id] #Cambiar por los de stores_inventories
      else
        @products_prices << [product.price.round(2), product.id]
      end
    end
    services.each do |service|
      @products_ids << [service.unique_code]
      @products_codes << [service.unique_code, service.unique_code]
      @products_description << [service.description, service.unique_code]
      @products_sat_keys << [service.sat_key.sat_key, service.unique_code]
      @products_sat_unit_keys << [service.sat_unit_key.unit, service.unique_code]
      @products_units << [service.sat_unit_key.description, service.unique_code]
      @products_prices << [service.price, service.unique_code]
    end
  end

  def filter_global_products
    @byll_types = []
    TypeOfBill.find_each do |tb|
      string = tb.key + ' ' + '-' + tb.description
      @byll_types << [string, tb.id]
    end
  end

  def form
    select_store
    select_stores_info
    select_payment_forms
    select_payment_conditions
    select_payment_methods
    select_cfdi_use
    get_time
    filter_product_options
  end

  def global_form
    select_store
    select_stores_info
    select_general_prospect_info
    select_payment_forms
    select_payment_conditions
    select_payment_methods
    select_cfdi_use
    get_time
    filter_global_products
  end

  def select_tickets
    user_role = current_user.role.name
    permitted_roles = ['store', 'store-admin']
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless permitted_roles.include?(user_role)

    store = current_user.store
    @tickets = store.tickets.where(parent:nil).where(bill: nil)
  end

  def select_orders(user_role = current_user.role.name)
    permitted_roles = ['admin-desk']
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless permitted_roles.include?(user_role)
    @orders = Order.where.not(status: 'entregado').where(bill: nil)
    # Cambiar cuando reestructure la información
  end

  def select_info
    if Store.all.where(store_type_id: 2).pluck(:id).include?(current_user.store.id)
      select_payment_forms
      select_payment_conditions
      select_payment_methods
    end
    params[:tickets] == nil ? @tickets = nil : @tickets = Ticket.find(params[:tickets])
    (params[:orders] == nil || params[:orders] == "") ? @orders = nil : @orders = Order.find(params[:orders])
    params[:bills] == nil ? @bills = nil : @bills = Bill.find(params[:bills])
    if (@tickets == nil  && @orders == nil)
      objects = @bills
    elsif (@tickets == nil && @bills == nil)
      objects = @orders
      if objects.length > 1
        @notes = "Pedidos "
        @orders.each do |order|
          @notes << "#{order.id}, "
        end
        @notes.chomp!(", ")
      else
        @notes = "Pedido #{@orders.first.id}"
      end
    elsif (@bills == nil  && @orders == nil)
      objects = @tickets
      if objects.length > 1
        @notes = "Tickets "
        @tickets.each do |ticket|
          @notes << "#{ticket.ticket_number}, "
        end
        @notes.chomp!(", ")
      else
        @notes = "Ticket #{@tickets.first.ticket_number}"
      end
    end
    get_prospect_from_objects(objects)
    if objects.first.is_a?(Ticket)
      get_cfdi_use_from_tickets(@tickets)
    else
      preferred = @prospect&.preferred_bill_option
      @payment_form = preferred&.payment_form_id
      @payment_method = preferred&.payment_method_id
      @payment_condition = preferred&.payment_condition
      if preferred != nil && preferred.cfdi_use_id != nil
        @cfdi_use = CfdiUse.find(preferred.cfdi_use_id)
      else
        @cfdi_use = CfdiUse.first
      end
    end
    @type_of_bill = TypeOfBill.first
    @tickets = params[:tickets] unless params[:tickets] == nil
    @orders = params[:orders] unless params[:orders] == nil
  end

  def global_preview
  end

  def get_date_from_pac
    #Savon crea un nuevo cliente SOAP
    client_date = Savon.client(wsdl: ENV['utilities_dir'])

    #Correo y contraseña de acceso al panel de FINKOK
    username = ENV['username_pac']
    password = ENV['password_pac']
    #Codigo postal a utilizar en el atributo LugarExpedicion
    zipcode = @store.zip_code

    #Consume el webservice y se cargan los parametros de envío
    response_date = client_date.call(:datetime, message: { username: username, password: password, zipcode: zipcode })

    #Obtiene el SOAP Request y lo guarda en un archivo
    ops_date = client_date.operation(:datetime)
    request_date = ops_date.build(message: { username: username, password: password, zipcode: zipcode })

    response_hash = response_date.hash

    date_pac = response_hash[:envelope][:body][:datetime_response][:datetime_result][:datetime]
    @date_pac = date_pac.strftime('%FT%T')

    response_hash = response.hash

    #Obtiene el SOAP Request y guarda la respuesta en un archivo
    soap_request = File.open(File.join(@working_dir, 'SOAP_Request_datetime.xml'), 'w') do |file|
      file.write(request_date)
    end

    #Obtiene el SOAP Response y guarda la respuesta en un archivo
    soap_response = File.open(File.join(@working_dir, 'SOAP_Response_datetime'), 'w') do |file|
      file.write(response_hash)
    end

  end

  def preview
    select_payment_forms
    select_payment_methods
    @notes = params[:notes]
    @relation_type = params[:relation_type]
    params[:bill] == nil ? @bill = nil : @bill = Bill.find(params[:bill])
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    (params[:orders] == nil || params[:orders] == "") ? orders = nil : orders = Order.find(params[:orders])
    if (tickets.nil? && @bill.nil? || @bill != nil && params[:relation_type] == '04')
      @objects = orders
    elsif (orders.nil? && @bill.nil? || @bill != nil && params[:relation_type] == '04')
      @objects = tickets
    else
      @objects = @bill
    end
    if @objects.class != Bill
      @objects.each do |object|
        if object.bill != nil
          @bill = object.bill
          @relation_type = '04'
        end
      end
    end
    if @bill != nil && @relation_type != '04'
      @store = @bill.store
      @bill.bill_type == 'global' ? @cfdi_type = 'global' : @cfdi_type = nil
      get_series_and_folio
    end
    # @relation_type == '01' es Nota de crédito, @relation_type == '03' es Devolución
    # @relation_type == '04' # Sustitución de factura
    # @relation_type == '07' # Aplicación de anticipo
    # Si es cancelación no, sustitución hay que revisar
    if @relation_type == '00' # Cancelación
      @time = Time.now.strftime('%FT%T')
      create_directories
      get_date_from_pac
      @time = @date_pac
      cancel_uuid
    else
      select_store if @bill == nil
      if @bill == nil
        @store = current_user.store
      else
        @store = @bill.store
      end
      if (params[:cfdi_type] == 'global' || @cfdi_type == 'global')
        if params[:foreigner].present?
          @prospect = Prospect.where(legal_or_business_name:'Residente en el extranjero', direct_phone: 1111111111, prospect_type: 'residente en el extranjero', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
          @foreign = true
        else
          @prospect = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
        end
      else
        if @bill == nil
          get_prospect_from_objects(@objects)
        else
          @prospect = @bill.prospect
        end
      end
      prospect = @prospect || Prospect.find(params[:prospect]).first

      @time = Time.now.strftime('%FT%T')
      if prospect.billing_address == nil
        redirect_to tickets_sales_summary_path, notice: "El cliente elegido no tiene datos de facturación registrados."
      else
        if (params[:cfdi_type] == 'global' || @cfdi_type == 'global')
          @general_bill = true
          store = @store
          p_billing = prospect.billing_address
          s_billing = store.business_unit.billing_address
          @date = Time.now.strftime('%FT%T')
          @zipcode = store.zip_code
          if params[:type_of_bill].present?
            type_of_bill = TypeOfBill.find(params[:type_of_bill])
          else
            type_of_bill = @type_of_bill
          end
          @bill_type = type_of_bill
          @type_of_bill_key = type_of_bill.key
          @type_of_bill_description = type_of_bill.description
          @store_rfc = s_billing.rfc.upcase
          @prospect_rfc = p_billing.rfc.upcase
          @store_name = s_billing.business_name
          @prospect_name = ''
          regime = s_billing.tax_regime
          @regime = regime
          @tax_regime_key = s_billing.tax_regime.tax_id
          @tax_regime = s_billing.tax_regime.description
          cfdi_use = CfdiUse.find_by_key('P01')
          @cfdi_use_key = cfdi_use.key
          @cfdi_use = cfdi_use.description
          if @bill != nil
            @payment_key  = @bill.payment_form.payment_key # Forma de pago
            @payment_description = @bill.payment_form.description # Forma de pago
            @method_key = PaymentMethod.find_by_method('PUE').method # Método de pago
            @method_description = PaymentMethod.find_by_method('PUE').description # método de pago
            @payment_form = @bill.payment_conditions # Condiciones de pago
            if @bill.status == 'cancelada'
              rows(@general_bill, @objects)
            else
              @rows = @bill.rows
            end
          else
            greatest_payment_key
            if @greatest_payment == nil
              @greatest_payment = PaymentForm.find_by_payment_key('99')
              # aquí revisar los pagos para orders
              @payment_key = @greatest_payment.payment_key
              @payment_description = @greatest_payment.description
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
            else
              @payment_key = @greatest_payment.payment_key
              @payment_description = @payments.first.first
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
              @rows
            end
          end
          subtotal
          total_taxes
          total
          total_discount
          if @total_discount.to_f > 0
            @discount_any = true
          else
            @discount_any = false
          end
          if params[:relation_type] != nil && params[:relation_type] != ''
            relation_type = RelationType.find_by_key(params[:relation_type])
            @relation = relation_type
            @relation_type = relation_type.key
          elsif @relation_type != nil
            if @relation_type.class == String
              relation_type = RelationType.where(key: @relation_type)&.first
              @relation = relation_type
            else
              relation_type = RelationType.find(@relation_type)&.first
              @relation = relation_type
              @relation_type = relation_type.key
            end
          end
          @relation_type == '01' ? @credit_note = true : @credit_note = false

          unless @objects.class == Bill
            if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
              @relation_type = '' if @relation_type != '04'
              get_series_and_folio
            end
          end
          @series
          @folio
          render 'global_preview'
        else
          if params[:prospect].present?
            prospect = Prospect.find(params[:prospect]).first
          else
            prospect = @bill.prospect
          end
          @prospect = prospect
          @general_bill = false
          store = @store
          s_billing = store.business_unit.billing_address
          p_billing = prospect.billing_address
          @date = Time.now.strftime('%FT%T')
          @zipcode = store.zip_code
          if params[:type_of_bill].present?
            type_of_bill = TypeOfBill.find(params[:type_of_bill])
          else
            type_of_bill = @type_of_bill
          end
          @bill_type = type_of_bill
          @type_of_bill_key = type_of_bill.key
          @type_of_bill_description = type_of_bill.description
          @store_rfc = s_billing.rfc.upcase
          @prospect_rfc = p_billing.rfc.upcase
          @store_name = s_billing.business_name
          @prospect_name = p_billing.business_name
          regime = s_billing.tax_regime
          @regime = regime
          @tax_regime_key = s_billing.tax_regime.tax_id
          @tax_regime = s_billing.tax_regime.description
          # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL CfdiUse.find_by_key('P01')

          ### AQUÍ TENGO QUE CAMBIAR
          if @bill == nil
            cfdi_use = CfdiUse.find(params[:cfdi_use]).first
          elsif (@bill != nil && (@relation_type == '01' || @relation_type == '03') )
            cfdi_use = CfdiUse.find_by_key('G02')
          else
            cfdi_use = CfdiUse.find(params[:cfdi_use]).first
          end
          @cfdi_use_key = cfdi_use.key
          @cfdi_use = cfdi_use.description
          if @bill != nil && @relation_type != '04'
            @payment_key  = @bill.payment_form.payment_key # Forma de pago
            @payment_description = @bill.payment_form.description # Forma de pago
            @method_key = PaymentMethod.find_by_method('PUE').method # Método de pago
            @method_description = PaymentMethod.find_by_method('PUE').description # método de pago
            @payment_form = @bill.payment_conditions # Condiciones de pago
            if @bill.status == 'cancelada'
              rows(@general_bill, @objects)
            else
              @rows = @bill.rows
            end
          else
            greatest_payment_key
            if @greatest_payment == nil
              @greatest_payment = PaymentForm.find_by_payment_key('99')
              # aquí revisar los pagos para orders
              @payment_key = @greatest_payment.payment_key
              @payment_description = @greatest_payment.description
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
            else
              @payment_key = @greatest_payment.payment_key
              @payment_description = @payments.first.first
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
              @rows
            end
          end
          if params[:payment].present? && params[:method].present? && params[:payment_form].present?
            if Store.all.where(store_type_id: 2).pluck(:id).include?(current_user.store.id)
              pay_form = PaymentForm.find(params[:payment])
              @payment_key = pay_form.payment_key
              @payment_description = pay_form.description
              pay_method = PaymentMethod.find(params[:method])
              @method_key = pay_method.method
              @method_description = pay_method.description
              @payment_form = params[:payment_form]
            end
          end
          subtotal
          total_taxes
          total
          total_discount
          if @total_discount.to_f > 0
            @discount_any = true
          else
            @discount_any = false
          end
          if params[:relation_type] != nil && params[:relation_type] != ''
            relation_type = RelationType.find_by_key(params[:relation_type])
            @relation = relation_type
            @relation_type = relation_type.key
          elsif @relation_type != nil
            if @relation_type.class == String
              relation_type = RelationType.where(key: @relation_type)&.first
              @relation = relation_type
            else
              relation_type = RelationType.find(@relation_type)&.first
              @relation = relation_type
              @relation_type = relation_type.key
            end
          end
          @relation_type == '01' ? @credit_note = true : @credit_note = false

          unless @objects.class == Bill
            if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
               @relation_type = '' if @relation_type != '04'
              get_series_and_folio
            end
          end
        end
      end
    end
  end

  def get_series_and_folio
    if (@relation_type == '' || @relation_type == '04' || @relation_type == nil)
      @series = @store.series
      @folio = @store.bill_last_folio.to_i.next
      @type_of_bill = TypeOfBill.find_by_key('I')
    elsif @relation_type == '01'
      @series = 'NC'+ @store.store_code
      @folio = @store.credit_note_last_folio.to_i.next
      @credit_note = true
      @type_of_bill = TypeOfBill.find_by_key('E')
    elsif @relation_type == '02'
      @series = 'ND'+ @store.store_code
      @folio = @store.debit_note_last_folio.to_i.next
      @type_of_bill = TypeOfBill.find_by_key('I')
    elsif @relation_type == '03'
      @series = 'DE'+ @store.store_code
      @folio = @store.return_last_folio.to_i.next
      @type_of_bill = TypeOfBill.find_by_key('E')
    elsif (@relation_type == '07' && @type_of_bill_key == 'I')
      @series = 'FA'+ @store.store_code
      @folio = @store.advance_e_last_folio.to_i.next
      @type_of_bill = TypeOfBill.find_by_key('I')
    elsif (@relation_type == '07' && @type_of_bill_key == 'E')
      @series = 'FE'+ @store.store_code
      @folio = @store.advance_i_last_folio.to_i.next
      @type_of_bill = TypeOfBill.find_by_key('E')
    else
      @series = nil
      @folio = nil
    end
  end

  def get_payments
    objects = @objects
    payments = []
    real_payments = []
    if objects.first.is_a?(Ticket)
      objects.each do |object|
        object.payments.each do |payment|
          payments << [payment.payment_form.description, payment.total] if payment.payment_type == 'pago'
          payments << [payment.payment_form.description, -payment.total] if payment.payment_type == 'devolución'
          real_payments << payment if (payment.payment_type == 'pago' || payment.payment_type == 'devolución')
        end
        object.children.each do |children|
          children.payments.each do |pay|
            payments << [pay.payment_form.description, pay.total] if pay.payment_type == 'pago'
            payments << [pay.payment_form.description, -pay.total] if pay.payment_type == 'devolución'
            real_payments << pay if (pay.payment_type == 'pago' || pay.payment_type == 'devolución')
          end
        end
      end
    else
      objects.each do |object|
        object.payments.each do |payment|
          payments << [payment.payment_form.description, payment.total] unless payment.payment_type == 'crédito'
          real_payments << payment
        end
      end
    end
    @list_of_real_payments = real_payments
    @list_of_payments = payments
    @payments = payments.group_by(&:first).map{ |k,v| [k, v.inject(0){ |sum, i| (sum + i.second).round(2) }] }.sort_by{|pay_form| pay_form.second}.reverse
    total_payment = []
    @payments.each do |payment|
      total_payment << payment.second
    end
    @total_payment = total_payment.inject(&:+)
    if @total_payment == nil
      @total_payment = 0
    end
    @total_payment = @total_payment.round(2)
  end

  def greatest_payment_key
    get_payments
    @greatest_payment = PaymentForm.find_by_description(@payments&.first&.first)
    @greatest_payment
  end

  def get_returns_or_changes_(ticket)
    difference = []
    ticket.children.each do |ticket|
      if ticket.ticket_type == 'devolución'
        difference << ticket.total
      end
    end
    difference = difference.inject(&:+)
    difference == nil ? @difference = 0 : @difference = difference
    @difference
  end

  def get_total_with_returns_or_changes_(ticket)
    get_returns_or_changes_(ticket)
    @ticket_total = ticket.total - @difference
    @ticket_total
  end

  def payment_method_(objects, total_payments, list_of_payments)
    total_all_objects = 0
    objects.each do |o|
      if objects.first.is_a?(Ticket)
        get_total_with_returns_or_changes_(o)
        total_all_objects += @ticket_total
      else
        total_all_objects += o.total
      end
    end
    @payed = false
    total_all_objects = total_all_objects.round(2)
    if total_all_objects <= total_payments.to_f
      @payed = true
      method = PaymentMethod.find_by_method('PUE')
    else
      method = PaymentMethod.find_by_method('PPD')
    end
    @total_all_objects = total_all_objects
    @method = method
    payment_form(@method, list_of_payments)
    @method
  end

  def payment_form(method, list_of_payments)
    credit_payments = []
    if method.method == 'PUE'
      @payment_form = 'Contado'
    else
      list_of_payments.each do |payment|
        credit_payments << payment.credit_days unless (payment.credit_days == nil || payment.credit_days == 0 || payment.credit_days == '')
      end
      days = credit_payments.sort.reverse.first
      @payment_form = 'Crédito'
      @payment_form += ' ' + days.to_s + ' ' + 'días' unless (days == nil || days == [] || days == [''] || days == '')
    end
    @payment_form
  end

  def subtotal
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.subtotal
      else
        amounts << row["subtotal"]
      end
    end
    subtotal = amounts.inject(&:+)
    @subtotal = subtotal.round(2)
    @subtotal
  end

  def total_taxes
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.taxes
      else
        amounts << row["taxes"]
      end
    end
    total_taxes = amounts.inject(&:+)
    @total_taxes = total_taxes.round(2)
    @total_taxes
  end

  def total
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.total
      else
        amounts << row["total"]
      end
    end
    total = amounts.inject(&:+)
    @total = total.round(2)
    @total
  end

  def total_discount
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.discount
      else
        amounts << row["discount"]
      end
    end
    @total_discount = amounts.inject(&:+)
    @total_discount
  end

  def new_subtotal
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.subtotal
      else
        amounts << row["subtotal"]
      end
    end
    subtotal = amounts.inject(&:+)
    @subtotal = subtotal.round(2)
    @subtotal
  end

  def new_total_taxes
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.taxes
      else
        amounts << row["taxes"]
      end
    end
    total_taxes = amounts.inject(&:+)
    @total_taxes = total_taxes.round(2)
    @total_taxes
  end

  def new_total
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.total
      else
        amounts << row["total"]
      end
    end
    total = amounts.inject(&:+)
    @total = total.round(2)
    @total
  end

  def new_total_discount
    amounts = []
    @rows.each do |row|
      if @bill != nil && @relation_type != '04'
        amounts << row.discount
      else
        amounts << row["discount"]
      end
    end
    @total_discount = amounts.inject(&:+)
    @total_discount
  end

  def variables_needed
    # si es normal:
    @relation_type # para saber si es factura o nota de credito
    @bill # para saber si es de una factura (como las vamos a ligar?) usando el mismo metodo de SIEMPRE
    @series
    @folio
    @zipcode

    # Pueden ser de estas:
    @rows
    row["sat_key"]
    row["unique_code"]
    row["description"]
    row["quantity"]
    row["sat_unit_key"]
    row["sat_unit_description"]
    row["unit_value"]
    row["discount"]
    row["taxes"]
    row["subtotal"]
    subtotal (metodo)
    total_discount (metodo)
    total_taxes
    total
    # Agregar un select para relacionar Facturas y CFDI relacionado
    # Agregar una variable que valide si entro por form y si es asi, enviar todo correcto a cfdi_process por medio de otro metodo

    @relation_type
    @relation_type_description
    @bill.uuid
    @store_rfc
    @prospect_rfc
    @store
    @objects
    a.split(' ').first #Para el nombre del producto
    # Tal vez tenga que cambiar el else de if tickets == nil para agregar este escenario

    @error = false
    @pdf_file = File.open(File.join(@final_dir, 'factura.pdf'), 'r')

    bill = Bill.new.tap do |bill|
      bill.status = 'creada'
      bill.issuing_company = @s_billing
      bill.receiving_company = @p_billing
      bill.prospect = @prospect
      bill.store = @store
      bill.sequence = @series
      bill.folio = @folio
      bill.payment_conditions = @payment_form
      bill.payment_method = @method
      bill.payment_form = @greatest_payment
      bill.subtotal = @subtotal
      bill.taxes = @total_taxes
      bill.total = @total
      bill.discount_applied = @total_discount
      # bill.automatic_discount_applied = @total_discount
      # bill.manual_discount_applied = @total_discount
      bill.tax = Tax.find(2)
      bill.tax_regime = @regime
      bill.taxes_transferred = @total_taxes
      # bill.taxes_witheld =
      bill.cfdi_use = @use
      # bill.pac =
      bill.relation_type = @relation
      # bill.references_field = ''
      bill.type_of_bill = @bill_type
      bill.currency = Currency.find_by_name('MXN')
      # bill.id_trib_reg_num = ''
      # bill.confirmation_key =
      bill.exchange_rate = 1.0
      bill.country = Country.find_by_name('México')
      bill.sat_certificate_number = @sat_certificate
      bill.certificate_number = @store.certificate_number
      bill.qr_string = @qr_string
      bill.original_chain = @stamp_original_chain
      bill.sat_stamp = @sat_seal
      bill.digital_stamp = @cfd_stamp
      bill.sat_zipcode_id = @store.zip_code
      bill.date_signed = @date
      bill.leyend = ''
      bill.uuid = @uuid
      bill.payed = @payed
      @objects.class == Bill ? bill.from = @bill.class.to_s : bill.from = @objects.first.class.to_s
      @general_bill == true ? bill.bill_type = 'global' : bill.bill_type = 'cliente'
      bill.parent = @bill
      if @relation&.id == 1
        bill.bill_folio_type = "Nota de Crédito"
      elsif @relation&.id == 2
        bill.bill_folio_type = "Nota de Débito"
      elsif @relation&.id == 3
        bill.bill_folio_type = "Devolución"
      elsif @relation&.id == 4
        bill.bill_folio_type = "Sustitución"
      elsif @relation&.id == 7
        bill.bill_folio_type = "Aplicación de Anticipo"
      elsif @series.include?("FA")
        bill.bill_folio_type = "Anticipo"
      else
        bill.bill_folio_type = "Factura"
      end
    end
  end

  def rows_for_form
    @rows = []
    @subtotal = params["bill_subtotal"].to_f
    @taxes = params["bill_taxes"].to_f
    @total_taxes = params["bill_taxes"].to_f
    @discount = params["bill_discount"].to_f
    @total_discount = params["bill_discount"].to_f
    @total = params["bill_total"].to_f
    check_for_discount
    params["quantity"].length.times do |n|
      new_hash = Hash.new.tap do |hash|
        hash["product_id"] = params["product_id"][n]
        hash["unique_code"] = params["unique_code"][n].split(' ').first
        hash["quantity"] = params["quantity"][n]
        hash["unit_value"] = params["unit_value_hidden"][n].to_f
        if Product.find_by_unique_code(params["unique_code"][n].split(' ').first) != nil
          hash["sat_key"] = Product.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_key.sat_key
          hash["sat_unit_key"] = Product.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_unit_key.unit
          hash["sat_unit_description"] = Product.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_unit_key.description
        else
          hash["sat_key"] = Service.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_key.sat_key
          hash["sat_unit_key"] = Service.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_unit_key.unit
          hash["sat_unit_description"] = Service.find_by_unique_code(params["unique_code"][n].split(' ').first).sat_unit_key.description
        end
        hash["description"] = params["product_description"][n]
        hash["total"] = (params["subtotal"][n].to_f - params["discount"][n].to_f + params["taxes"][n].to_f)
        hash["subtotal"] = params["subtotal"][n].to_f
        hash["taxes"] = params["taxes"][n].to_f
        hash["discount"] = params["discount"][n].to_f
      end
      @rows << new_hash
    end
  end

  def check_for_discount
    if @total_discount.to_f > 0
      @discount_any = true
    else
      @discount_any = false
    end
  end

  def rows_for_global_form
    @rows = []
    @subtotal = params["bill_subtotal"].to_f
    @taxes = params["bill_taxes"].to_f
    @total_taxes = params["bill_taxes"].to_f
    @total_discount = params["bill_discount"].to_f
    @discount = params["bill_discount"].to_f
    @total = params["bill_total"].to_f
    check_for_discount
    params["quantity"].length.times do |n|
      new_hash = Hash.new.tap do |hash|
        hash["ticket"] = params["tickets"][n]
        hash["quantity"] = params["quantity"][n]
        hash["unit_value"] = params["unit_value"][n].to_f
        hash["sat_key"] = params["sat_key"][n]
        hash["sat_unit_key"] = params["sat_key"][n]
        hash["description"] = params["sat_unit_description"][n]
        hash["total"] = (params["subtotal"][n].to_f - params["discount"][n].to_f + params["taxes"][n].to_f)
        hash["subtotal"] = params["subtotal"][n].to_f
        hash["taxes"] = params["taxes"][n].to_f
        hash["discount"] = params["discount"][n].to_f
      end
      @rows << new_hash
    end
  end

  def cfdi_process
    @foreign = true if params[:foreign].present?
    @notes = params[:notes]
    if (params['form'].present? || params['global_form'].present?)
      @relation_type = ''
      @store = Store.find(params['store_name']).first
      store = @store
      s_billing = store.business_unit.billing_address
      @s_billing = s_billing
      @store_rfc = s_billing.rfc.upcase
      @store_name = s_billing.business_name
      regime = s_billing.tax_regime
      @regime = regime
      @tax_regime_key = s_billing.tax_regime.tax_id
      @tax_regime = s_billing.tax_regime.description
      if params['form'].present?
        if (current_user.store.id == 1 || current_user.store.id == 2)
          bl = BillingAddress.where(business_name: params['prospect_name'], rfc: params['prospect_rfc'])
        else
          bl = BillingAddress.where(business_name: params['prospect_name'], rfc: params['prospect_rfc'])
        end
        bl.each do |b|
          b.prospects.each do |p|
            if !(current_user.store.id == 1 || current_user.store.id == 2)
              if p.store == @store
                @prospect = p
              end
            else
              @prospect = p
            end
          end
        end
        @prospect_name = params['prospect_name']
      elsif params['global_form'].present?
        @prospect = Prospect.find(params['prospect_name']).first
        @prospect_name = ''
      end
      prospect = @prospect
      p_billing = prospect.billing_address
      @prospect_rfc = p_billing.rfc.upcase
      @p_billing = p_billing
      @date = @date_pac || Time.now.strftime('%FT%T')
      @zipcode = store.zip_code
      cfdi_use = CfdiUse.find(params['cfdi_use'])
      @use = cfdi_use
      @cfdi_use_key = cfdi_use.key
      @cfdi_use = cfdi_use.description
      @series = store.series
      @folio = store.bill_last_folio.next
      @zipcode = store.zip_code
      type_of_bill = TypeOfBill.find(params["type_of_bill"])
      @type_of_bill = type_of_bill
      @type_of_bill_key = type_of_bill.key
      @type_of_bill_description = type_of_bill.description
      @store_rfc = store.business_unit.billing_address.rfc
      @prospect_rfc = prospect.billing_address.rfc
      @store_name = store.business_unit.billing_address.business_name
      @prospect_name = prospect.billing_address.business_name
      @tax_regime_key = store.business_unit.billing_address.tax_regime.tax_id
      @tax_regime = store.business_unit.billing_address.tax_regime.description
      @pay_form = PaymentForm.find(params['payment'])
      @payment_form = params['payment_form']
      @payment_key = @pay_form.payment_key
      @payment_description = @pay_form.description
      @method = PaymentMethod.find(params['method'])
      @method_key = @method.method
      @method_description = @method.description
      @relation_type_description = nil
      @time = Time.now.strftime('%FT%T')
      @greatest_payment = @pay_form
      @bill_type = type_of_bill
      if params['form'].present?
        rows_for_form
        @general_bill = false
      elsif params['global_form'].present?
        rows_for_global_form
        @general_bill = true
      end
      create_directories
      get_date_from_pac
      @time = @date_pac
      create_unsigned_xml_file
      generate_digital_stamp
      get_stamp_from_pac
      if @cod_status == 'Comprobante timbrado satisfactoriamente'
        qrcode_print
        generate_pdf
        save_to_db
        if @error
          redirect_to root_path, alert: 'Hubo un error con el proceso, por favor intente de nuevo.'
        else
          redirect_to root_path, notice: 'Su factura ha sido generada con éxito.'
        end
      else
        redirect_to root_path, alert: @incidents_hash[:incidencia][:mensaje_incidencia]
      end
    else
      if params[:bill] != nil
        @bill = Bill.find(params[:bill])
      end
      (params[:tickets] == nil || params[:tickets] == "") ? tickets = nil : tickets = Ticket.where(id: params[:tickets].split("/"))
      (params[:orders] == nil || params[:orders] == "") ? orders = nil : orders = Order.find(params[:orders].split("/"))
      tickets == nil ? @objects = orders : @objects = tickets
      if (tickets.nil? && @bill.nil? || @bill != nil && params[:relation_type] == '04' && tickets.nil?)
        @objects = orders
      elsif (orders.nil? && @bill.nil? || @bill != nil && params[:relation_type] == '04' && orders.nil?)
        @objects = tickets
      else
        @objects = @bill
      end
      if @bill != nil && @relation_type != '04'
        @store = @bill.store
        @bill.bill_type == 'global' ? @cfdi_type == 'global' : @cfdi_type == nil
        @relation_type = params[:relation_type]
        get_series_and_folio
      end
      if @bill == nil
        @store = current_user.store
      else
        @store = @bill.store
      end
      @time = Time.now.strftime('%FT%T')
      if params[:cfdi_type] == 'global'
        @general_bill = true
        store = @store
        s_billing = store.business_unit.billing_address
        @s_billing = s_billing
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL prospect = Prospect.find_by_legal_or_business_name('Público en General')
        if @foreign == true
          prospect = Prospect.where(legal_or_business_name:'Residente en el extranjero', direct_phone: 1111111111, prospect_type: 'residente en el extranjero', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
        else
          prospect = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
        end
        @prospect = prospect
        p_billing = prospect.billing_address
        @p_billing = p_billing
        @date = @date_pac || Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        if params[:type_of_bill].present?
          type_of_bill = TypeOfBill.find(params[:type_of_bill])
        else
          type_of_bill = @type_of_bill
        end
        @bill_type = type_of_bill
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @type_of_bill_description = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name
        @prospect_name = ''
        regime = s_billing.tax_regime
        @regime = regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description
        cfdi_use = CfdiUse.find_by_key('P01')
        @use = cfdi_use
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description

        if @bill != nil || (@bill != nil && @relation_type == '04')
          @payment_key  = @bill.payment_form.payment_key # Forma de pago
          @payment_description = @bill.payment_form.description # Forma de pago
          @method_key = PaymentMethod.find_by_method('PUE').method # Método de pago
          @method_description = PaymentMethod.find_by_method('PUE').description # método de pago
          @payment_form = @bill.payment_conditions # Condiciones de pago
          if @relation_type == '01'
            @rows = []
            total = params[:amount].to_f.round(2)
            subtotal = (total / 1.16).round(2)
            taxes = total - subtotal
            percentage = ((total / @bill.total) * 100).round(2).to_s
            @new_row = Row.new.tap do |r|
              r.quantity = 1
              r.description = "Descuento del #{percentage}%"
              r.unit_value = subtotal
              r.sat_unit_key = SatUnitKey.find_by_unit('ACT').unit
              r.sat_unit_description = SatUnitKey.find_by_unit('ACT').description
              r.sat_key = SatKey.find_by_description('Servicios de facturación').sat_key
              r.total = total
              r.subtotal = subtotal
              r.discount = 0
              r.taxes = taxes
            end
            @rows << @new_row
          else
            if @greatest_payment == nil
              @greatest_payment = PaymentForm.find_by_payment_key('99')
              # aquí revisar los pagos para orders
              @payment_key = @greatest_payment.payment_key
              @payment_description = @greatest_payment.description
              get_payments
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
              @rows
            else
              @payment_key = @greatest_payment.payment_key
              @payment_description = @payments.first.first
              get_payments
              payment_method_(@objects, @total_payment, @list_of_real_payments)
              @method_description = @method.description
              @method_key = @method.method
              @payment_form
              rows(@general_bill, @objects)
              @rows
            end
          end
        else
          greatest_payment_key
          if @greatest_payment == nil
            @greatest_payment = PaymentForm.find_by_payment_key('99')
            # aquí revisar los pagos para orders
            @payment_key = @greatest_payment.payment_key
            @payment_description = @greatest_payment.description
            payment_method_(@objects, @total_payment, @list_of_real_payments)
            @method_description = @method.description
            @method_key = @method.method
            @payment_form
            rows(@general_bill, @objects)
            @rows
          else
            @payment_key = @greatest_payment.payment_key
            @payment_description = @payments.first.first
            payment_method_(@objects, @total_payment, @list_of_real_payments)
            @method_description = @method.description
            @method_key = @method.method
            @payment_form
            rows(@general_bill, @objects)
            @rows
          end
        end
        new_subtotal
        new_total_taxes
        new_total
        new_total_discount
        if @total_discount.to_f > 0
          @discount_any = true
        else
          @discount_any = false
        end
        if (params[:relation_type] != nil && params[:relation_type] != '')
          relation_type = RelationType.find_by_key(params[:relation_type])
          @relation = relation_type
          @relation_type = relation_type.key
          @relation_type_description = relation_type.description
        elsif @relation_type != nil
          relation_type = RelationType.find(@relation_type)&.first
          @relation = relation_type
          @relation_type = relation_type.key
        end
        @relation_type == '01' ? @credit_note = true : @credit_note = false

        unless @objects.class == Bill
          if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
            @relation_type = '' if @relation_type != '04'
            get_series_and_folio
          end
        end
      else
        @general_bill = false
        store = @store
        s_billing = store.business_unit.billing_address
        @s_billing = s_billing
        if params[:prospect].present?
          prospect = Prospect.find(params[:prospect])
          if prospect.class == Array
            prospect = prospect.first
          end
        else
          prospect = @bill.prospect
        end
        @prospect = prospect
        p_billing = prospect.billing_address
        @p_billing = p_billing
        @date = @date_pac || Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        if params[:type_of_bill].present?
          type_of_bill = TypeOfBill.find(params[:type_of_bill])
        else
          type_of_bill = @type_of_bill
        end
        @bill_type = type_of_bill
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @type_of_bill_description = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name
        @prospect_name = p_billing.business_name
        regime = s_billing.tax_regime
        @regime = regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description

        if @bill == nil
          cfdi_use = CfdiUse.find(params[:cfdi_use])
        elsif (@bill != nil && (@relation_type == '01' || @relation_type == '03') )
          cfdi_use = CfdiUse.find_by_key('G02')
        else
          cfdi_use = CfdiUse.find(params[:cfdi_use])
        end
        cfdi_use = cfdi_use.first if cfdi_use.class == Array
        @use = cfdi_use
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description

        if @bill != nil && @relation_type != '04'
          @payment_key  = @bill.payment_form.payment_key # Forma de pago
          @payment_description = @bill.payment_form.description # Forma de pago
          @method_key = PaymentMethod.find_by_method('PUE').method # Método de pago
          @method_description = PaymentMethod.find_by_method('PUE').description # método de pago
          @payment_form = @bill.payment_conditions # Condiciones de pago
          if @relation_type == '03'
            @rows = []
            n = 0
            quantities_unfiltered = params[:quantities]
            products_unfiltered = params[:products]
            params[:services].present? ? services_unfiltered = params[:services] : services_unfiltered = []
            zeroes = quantities_unfiltered.each_index.select{|i| quantities_unfiltered[i] == '0'}
            quantities_filtered = quantities_unfiltered.delete_if.with_index{ |e,i| zeroes.include?(i) }
            products_filtered = products_unfiltered.delete_if.with_index{ |e,i| zeroes.include?(i) } if products_unfiltered != nil
            services_unfiltered != nil ? services_filtered = services_unfiltered.delete_if.with_index{ |e,i| zeroes.include?(i) } : services_filtered = services_unfiltered
            quantities_filtered.count.times do
              if products_filtered[n] == services_filtered[n]
                product = Service.find(products_filtered[n])
              else
                product = Product.find(products_filtered[n])
              end
              id = product.id
              if products_filtered[n] == services_filtered[n]
                unique_code = product.unique_code
                row = @bill.rows.select{|row| row.product.to_s == unique_code}.first
              else
                row = @bill.rows.select{|row| row.product == id}.first
              end
              new_row = Row.new.tap do |r|
                r.unique_code = row.unique_code
                r.quantity = quantities_filtered[n]
                r.description = product.description
                r.unit_value = row.unit_value
                r.sat_unit_key = row.sat_unit_key
                r.sat_unit_description = row.sat_unit_description
                r.sat_key = row.sat_key
                r.subtotal = (('%.2f' % (row.subtotal / row.quantity)).to_f * quantities_filtered[n].to_i).round(2)
                r.discount = (('%.2f' % (row.discount / row.quantity)).to_f * quantities_filtered[n].to_i).round(2)
                r.taxes = ((r.subtotal - r.discount) * 0.16).round(2)
                r.total = (r.subtotal - r.discount + r.taxes).round(2)
              end
              n += 1
              @rows << new_row
            end
          elsif @relation_type == '01'
            @rows = []
            total = params[:amount].to_f.round(2)
            subtotal = (total / 1.16).round(2)
            taxes = total - subtotal
            percentage = ((total / @bill.total) * 100).round(2).to_s
            @new_row = Row.new.tap do |r|
              r.quantity = 1
              r.description = "Descuento del #{percentage}%"
              r.unit_value = subtotal
              r.sat_unit_key = SatUnitKey.find_by_unit('ACT').unit
              r.sat_unit_description = SatUnitKey.find_by_unit('ACT').description
              r.sat_key = SatKey.find_by_description('Servicios de facturación').sat_key
              r.total = total
              r.subtotal = subtotal
              r.discount = 0
              r.taxes = taxes
            end
            @rows << @new_row
          end
        else
          greatest_payment_key
          if @greatest_payment == nil
            @greatest_payment = PaymentForm.find_by_payment_key('99')
            # aquí revisar los pagos para orders
            @payment_key = @greatest_payment.payment_key
            @payment_description = @greatest_payment.description
            payment_method_(@objects, @total_payment, @list_of_real_payments)
            @method_description = @method.description
            @method_key = @method.method
            @payment_form
            rows(@general_bill, @objects)
            @rows
          else
            @payment_key = @greatest_payment.payment_key
            @payment_description = @payments.first.first
            payment_method_(@objects, @total_payment, @list_of_real_payments)
            @method_description = @method.description
            @method_key = @method.method
            @payment_form
          end
          rows(@general_bill, @objects)
          @rows
        end
        new_subtotal
        new_total_taxes
        new_total
        new_total_discount
        if @total_discount.to_f > 0
          @discount_any = true
        else
          @discount_any = false
        end
        if params[:relation_type] != nil && params[:relation_type] != ''
          relation_type = RelationType.find_by_key(params[:relation_type])
          @relation = relation_type
          @relation_type = relation_type.key
          @relation_type_description = relation_type.description
        elsif (@relation_type != nil && params[:relation_type] == nil)
          relation_type = RelationType.find_by_key(@relation_type)
          @relation = relation_type
          @relation_type = relation_type.key
        end
        @relation_type == '01' ? @credit_note = true : @credit_note = false

        unless @objects.class == Bill
          if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
            @relation_type = '' if @relation_type != '04'
            get_series_and_folio
          end
        end
      end
      if params[:payment_form].present? && params[:payment_key].present? && params[:method_key].present?
        if Store.all.where(store_type_id: 2).pluck(:id).include?(current_user.store.id)
          pay_form = PaymentForm.where(payment_key: params[:payment_key]).first
          @greatest_payment = pay_form
          @payment_key = pay_form.payment_key
          @payment_description = pay_form.description
          @method = PaymentMethod.where(method: params[:method_key]).first
          @method_key = @method.method
          @method_description = @method.description
          @payment_form = params[:payment_form]
        end
      end

      if params[:payment].present? && params[:method].present?
        @pay_form = PaymentForm.find(params['payment'])
        @payment_form = params['payment_form']
        @payment_key = @pay_form.payment_key
        @payment_description = @pay_form.description
        @method = PaymentMethod.find(params['method'])
        @method_key = @method.method
        @method_description = @method.description
      end

      create_directories
      get_date_from_pac
      @time = @date_pac
      create_unsigned_xml_file
      generate_digital_stamp
      get_stamp_from_pac
      if @cod_status == 'Comprobante timbrado satisfactoriamente'
        qrcode_print
        generate_pdf
        save_to_db
        if @error
          redirect_to root_path, alert: 'Hubo un error con el proceso, por favor intente de nuevo.'
        else
          redirect_to root_path, notice: 'Su factura ha sido generada con éxito.'
        end
      else
        redirect_to root_path, alert: @incidents_hash[:incidencia][:mensaje_incidencia]
      end
    end
  end

  def create_directories
    # Detalla las variables necesarias para los directorios
    @store
    @p_rfc = @prospect_rfc
    @base = Rails.root.join('public', 'uploads')
    @unchanged_time = @time
    # Crea los directorios
    `mkdir -p -m 777 #{@base}/bill_files/#{@store.id}/"#{@time}"-"#{@p_rfc}"`
    `sudo chown -R ubuntu:ubuntu #{@base}/bill_files/#{@store.id}/"#{@time}"-"#{@p_rfc}"/`
    `mkdir -p -m 777 #{@base}/bill_files/#{@store.id}/"#{@time}"-"#{@p_rfc}"_final`
    `sudo chown -R ubuntu:ubuntu #{@base}/bill_files/#{@store.id}/"#{@time}"-"#{@p_rfc}"_final/`

    # Crea las variables de los directorios a utilizar
    @working_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@time}-#{@p_rfc}")
    @working_dir = "/home/ubuntu/MosaicOne007" + "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}"
    @final_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@time}-#{@p_rfc}_final")
    @final_dir = "/home/ubuntu/MosaicOne007" + "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}_final"
    @xml_path = "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}_final"
    @sat_path = Rails.root.join('lib', 'sat')
    @store_path = Rails.root.join('public', 'uploads', 'store', "#{@store.id}")
  end

  def select_pay_bills
    prospect_count = Payment.where(id: params[:payments]).joins("LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck("prospects.id").uniq.length
    if prospect_count > 1
      redirect_to bills_partially_payed_bills_path, alert: 'Ha seleccionado pagos de distintos clientes, por favor modifique la selección.'
    else
      @payments = Payment.find(params[:payments])
      get_store_and_zipcode
      get_type_of_bill_pay
      get_billing_address_info
      get_payments_array
      get_prospect_info
      get_cfdi_use_pay_bill
      pay_bill_series_and_folio
      get_time
      generate_bill_pay_rows
      render 'payment_bill_preview'
    end
  end

  def pay_cfdi_process
    @payments = Payment.find(params[:payments].split(" "))
    get_store_and_zipcode
    get_type_of_bill_pay
    get_billing_address_info
    get_payments_array_secondary
    get_prospect_info
    get_cfdi_use_pay_bill
    pay_bill_series_and_folio
    generate_bill_pay_rows
    total_for_pay_bill
    generate_aditional_info_for_rows
    @time = params[:time]
    create_directories
    get_date_from_pac
    @time = @date_pac
    @pay_bill = true
    create_additional_variables
    created_payment_cfdi
    generate_digital_stamp
    get_stamp_from_pac
    if @cod_status == 'Comprobante timbrado satisfactoriamente'
      qrcode_print
      generate_pdf
      save_to_db
      if @error
        redirect_to root_path, alert: 'Hubo un error al generar el REP, por favor intente de nuevo.'
      else
        redirect_to bills_partially_payed_bills_with_pay_bill_path, notice: 'Su REP ha sido generado con éxito.'
      end
    else
      redirect_to root_path, alert: @incidents_hash[:incidencia][:mensaje_incidencia]
    end
  end

  def cancel_pay_bill
    @time = Time.now.strftime('%FT%T')
    @bill = Bill.find(params[:payment])
    @store = @bill.store
    create_directories
    get_date_from_pac
    @time = @date_pac
    cancel_uuid
  end

  def partially_payed_bills_with_pay_bill
    filter_pay_bills
  end

  def get_store_and_zipcode
    @store = current_user.store
    @zipcode = @store.zip_code
  end

  def get_type_of_bill_pay
    type_of_bill = TypeOfBill.find_by_key('P')
    @type_of_bill_key = type_of_bill.key
    @type_of_bill_description = type_of_bill.description
  end

  def get_billing_address_info
    @store_rfc = @store.business_unit.billing_address.rfc.upcase
    @store_name = @store.business_unit.billing_address.business_name
    @tax_regime = @store.business_unit.billing_address.tax_regime.description
    @tax_regime_key = @store.business_unit.billing_address.tax_regime.tax_id
  end

  def get_payments_array
    filter_corporate_stores
    if @corporate_stores.include?(current_user.store.id)
      @payments_array = Payment.where(id: params[:payments]).joins(:payment_form).joins("LEFT JOIN orders ON orders.id = payments.order_id LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck("orders.id, payments.payment_date, orders.category, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id, bills.sequence, bills.folio, bills.uuid, payments.operation_number")
    else
      @payments_array = Payment.where(id: params[:payments]).joins(:ticket, :payment_form).joins("LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck("tickets.ticket_number, payments.payment_date, tickets.ticket_type, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id, bills.sequence, bills.folio, bills.uuid, payments.operation_number")
    end
    @pay_bills = @payments_array.map{ |arr| arr[9]}
  end

  def get_payments_array_secondary
    filter_corporate_stores
    if @corporate_stores.include?(current_user.store.id)
      @cancelled_bills = Bill.where(id: Payment.where(id: params[:payments].split(" ")).joins(:payment_form).joins("LEFT JOIN orders ON orders.id = payments.order_id LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck(:payment_bill_id)).pluck(:id, :uuid, :status)
      @relation_type = 4 unless @cancelled_bills == []

      @payments_array = Payment.where(id: params[:payments].split(" ")).joins(:payment_form).joins("LEFT JOIN orders ON orders.id = payments.order_id LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck("orders.id, payments.payment_date, orders.category, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id, bills.sequence, bills.folio, bills.uuid, payments.operation_number, payments.id, payment_forms.payment_key")
    else
      @cancelled_bills = Bill.where(id: Payment.where(id: params[:payments].split(" ")).joins(:ticket, :payment_form).joins("LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck(:payment_bill_id)).pluck(:id, :uuid, :status)
      @relation_type = 4 unless @cancelled_bills == []

      @payments_array = Payment.where(id: params[:payments].split(" ")).joins(:ticket, :payment_form).joins("LEFT JOIN bills ON payments.bill_id = bills.id LEFT JOIN prospects ON bills.prospect_id = prospects.id").order(:id).pluck("tickets.ticket_number, payments.payment_date, tickets.ticket_type, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id, bills.sequence, bills.folio, bills.uuid, payments.operation_number, payments.id, payment_forms.payment_key")
    end
    @pay_bills = @payments_array.map{ |arr| arr[9]}
  end


  def get_prospect_info
    @prospect = @payments_array.map{ |arr| arr[10]}.uniq.first
    billing_address = Prospect.find(@prospect).billing_address
    @prospect_rfc = billing_address.rfc.upcase
    @prospect_name = billing_address.business_name
  end

  def get_cfdi_use_pay_bill
    cfdi_use = CfdiUse.find_by_description("Por definir")
    @cfdi_use_key = cfdi_use.key
    @cfdi_use = cfdi_use.description
  end

  def pay_bill_series_and_folio
    @series = 'REP'+ @store.store_code
    @folio = @store.pay_bill_last_folio.to_i.next
  end

  def generate_bill_pay_rows
    @rows = []
    by_bill = @payments_array.group_by{ |arr| arr[11]}
    by_bill.keys.each do |folio|
      count = 1
      bill = Bill.find(by_bill[folio][0][11])
      difference = bill.children.sum(:total)
      total = by_bill[folio][0][6] - difference
      payed = by_bill[folio][0][3]
      due = total - payed
      by_bill[folio].each_with_index do |array, index|
        payed += array[3] unless index == 0
        total = due unless index == 0
        due -= array[3] unless index == 0
        due = 0 if due < 0
        array[3] = total if array[3].to_f > total
        @rows << [array[12] + ' ' + array[13], array[14], count, total, array[3], due, array[4], array[3], array[1], array[15].to_s, array[8], array[17], array[11]]
        count += 1
      end
    end
  end

  def total_for_pay_bill
    @total = @rows.sum{|arr| arr[4]}
  end

  def generate_aditional_info_for_rows
    if params[:payment_ids].present?
      @payments_ids = params[:payment_ids]
      @emisor_rfc = params[:emisor_rfc]
      @emisor_name = params[:emisor_name]
      @emisor_account = params[:emisor_account]
      @beneficiario_rfc = params[:beneficiario_rfc]
      @beneficiario_account = params[:beneficiario_account]
      params_index = @payments_ids.find_index{|arr| arr == arr[10].to_s}
    end
  end

  def partially_payed_bills
    filter_partially_payed
  end

  def filter_corporate_stores
    @corporate_stores = Store.joins(:store_type).where(store_types: {store_type: 'corporativo'}).pluck(:id)
  end

  def filter_pay_bills
    @bills = Bill.joins(:prospect).where(store_id: current_user.store.id, bill_folio_type: 'Pago', status: 'creada')
  end

  def filter_partially_payed
    initial_date = (Date.parse('2018-09-01') - 3.month).strftime('%F %H:%M:%S')
#    initial_date = Date.parse('2018-09-01').strftime('%F %H:%M:%S')
    final_date = Date.today.strftime('%F 23:59:59')

    filter_corporate_stores
    if @corporate_stores.include?(current_user.store.id)
      @payments = Payment.joins(:payment_form).joins("LEFT JOIN orders ON orders.id = payments.order_id LEFT JOIN bills ON (payments.bill_id = bills.id OR payments.payment_bill_id = bills.id) LEFT JOIN prospects ON bills.prospect_id = prospects.id").where("(payments.payment_bill_id IS NOT null AND bills.status = 'cancelada') OR (bills.created_at > '#{initial_date}' AND bills.created_at < '#{final_date}' AND bills.payment_method_id = 2 AND bills.status = 'creada' AND payments.payment_bill_id IS null)").where(store_id: nil, bills: {store_id: current_user.store.id}).where.not(payment_type: ['crédito', 'cancelado']).order(:id).pluck("orders.id, payments.payment_date, orders.category, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id")
    else
      @payments = Payment.joins(:ticket, :payment_form).joins("LEFT JOIN bills ON (payments.bill_id = bills.id OR payments.payment_bill_id = bills.id) LEFT JOIN prospects ON bills.prospect_id = prospects.id").where("(payments.payment_bill_id IS NOT null AND bills.status = 'cancelada') OR (bills.created_at > '#{initial_date}' AND bills.created_at < '#{final_date}' AND bills.payment_method_id = 2 AND bills.status = 'creada' AND payments.payment_bill_id IS null)").where(store_id: current_user.store.id).where.not(payment_type: ['crédito', 'cancelado']).order(:id).pluck("tickets.ticket_number, payments.payment_date, tickets.ticket_type, payments.total, payment_forms.description, prospects.legal_or_business_name, bills.total, bills.folio, payments.id, payments.payment_bill_id, prospects.id, payments.bill_id")
    end
  end

  def payment_bill_preview
  end

  def create_additional_variables
    Prospect.find(@prospect).legal_or_business_name == 'Público en General' ? @general_bill = true : @general_bill = false
    @use = CfdiUse.find_by_key('P01')
    @bill_type = TypeOfBill.find_by_key('P')
  end

  def created_payment_cfdi
    document = Hash.new.tap do |hash|
      hash["xmlns:cfdi"] = 'http://www.sat.gob.mx/cfd/3'
      hash["xmlns:xsi"] = 'http://www.w3.org/2001/XMLSchema-instance'
      hash["xsi:schemaLocation"] = 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd'
      hash["xmlns:pago10"] = 'http://www.sat.gob.mx/Pagos'
      hash["Version"] = '3.3'
      hash["Serie"] = @series
      hash["Folio"] = @folio
      hash["Fecha"] = @time
      hash["Sello"] = ''
      hash["NoCertificado"] = @store.certificate_number
      hash["Certificado"] = ''
      hash["SubTotal"] = 0
      hash["Moneda"] = 'XXX'
      hash["Total"] = 0
      hash["TipoDeComprobante"] = 'P'
      hash["LugarExpedicion"] = @zipcode
    end

    issuer = Hash.new.tap do |hash|
      hash["Rfc"] = @store_rfc
      hash["Nombre"] = @store_name
      hash["RegimenFiscal"] = @tax_regime_key
    end

    receiver = Hash.new.tap do |hash|
      hash["Rfc"] = @prospect_rfc
      hash["Nombre"] = @prospect_name
      hash["UsoCFDI"] = 'P01'
    end

    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml['cfdi'].Comprobante(document) do
        if @relation_type == 4
          xml['cfdi'].CfdiRelacionados('TipoRelacion' => '04' ) do
            @cancelled_bills.each do |bill|
              xml['cfdi'].CfdiRelacionado('UUID' => bill[1])
            end
          end
        end
        xml['cfdi'].Emisor(issuer)
        xml['cfdi'].Receptor(receiver)
        concept = Hash.new.tap do |hash|
          hash["ClaveProdServ"] = '84111506'
          hash["Cantidad"] = '1'
          hash["ClaveUnidad"] = 'ACT'
          hash["Descripcion"] = 'Pago'
          hash["ValorUnitario"] = '0'
          hash["Importe"] = '0'
        end
        xml['cfdi'].Conceptos do
          xml['cfdi'].Concepto(concept) do
          end
        end
        xml['cfdi'].Complemento do
          xml['pago10'].Pagos('Version' => '1.0') do
            @rows.each_with_index do |row, index|
              payment = Hash.new.tap do |hash|
                if params[:payment_ids].present?
                  params_index = params[:payment_ids].find_index{|arr| arr == row[10].to_s}
                end
                hash["FechaPago"] = row[8].strftime('%FT12:00:00')
                hash["FormaDePagoP"] = row[11]
                hash["MonedaP"] = 'MXN'
                hash["Monto"] = '%.2f' % row[7]
                hash["NumOperacion"] = row[9] unless row[9] == ""
                if params_index != nil
                  hash["RfcEmisorCtaOrd"] = params[:emisor_rfc][params_index] unless params[:emisor_rfc][params_index] == ""
                  hash["NomBancoOrdExt"] = params[:emisor_name][params_index] unless params[:emisor_name][params_index] == ""
                  hash["CtaOrdenante"] = params[:emisor_account][params_index] unless params[:emisor_account][params_index] == ""
                  hash["RfcEmisorCtaBen"] = params[:beneficiario_rfc][params_index] unless params[:beneficiario_rfc][params_index] == ""
                  hash["CtaBeneficiario"] = params[:beneficiario_account][params_index] unless params[:beneficiario_account][params_index] == ""
                end
              end
              xml['pago10'].Pago(payment) do
                related_doc = Hash.new.tap do |hash|
                  hash["IdDocumento"] = row[1]
                  hash["Serie"] = row[0].split(" ").first
                  hash["Folio"] = row[0].split(" ").second
                  hash["MonedaDR"] = 'MXN'
                  hash["MetodoDePagoDR"] = 'PPD'
                  hash["NumParcialidad"] = row[2]
                  hash["ImpSaldoAnt"] = '%.2f' % row[3]
                  hash["ImpPagado"] = '%.2f' % row[4]
                  hash["ImpSaldoInsoluto"] = '%.2f' % row[5]
                end
                xml['pago10'].DoctoRelacionado(related_doc) do
                end
              end
            end
          end
        end
      end
    end
    builder.to_xml.encoding
    unsigned = File.open(File.join(@working_dir, 'unsigned.xml'), 'w'){ |file| file.write(builder.to_xml) }
  end

  def create_unsigned_xml_file
    s = @store
    b = s.business_unit.billing_address
    p_b = @prospect.billing_address

    e_name = b.business_name
    e_name_clean = e_name

    r_name = p_b.business_name
    r_name_clean = r_name

    document = Hash.new.tap do |hash|
      hash["xmlns:cfdi"] = 'http://www.sat.gob.mx/cfd/3'
      hash["xmlns:xsi"] = 'http://www.w3.org/2001/XMLSchema-instance'
      hash["xsi:schemaLocation"] = 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd'
      hash["Version"] = '3.3'
      hash["Serie"] = @series
      hash["Folio"] = @folio
      hash["Fecha"] = @time
      hash["Sello"] = ''
      hash["FormaPago"] = @payment_key
      hash["NoCertificado"] = s.certificate_number
      hash["Certificado"] = ''
      hash["CondicionesDePago"] = @payment_form unless (@general_bill || @payment_form == '' || @payment_form == nil)
      if @foreign == true
        hash["SubTotal"] = '%.2f' % (@subtotal * 1.16)
      else
        hash["SubTotal"] = '%.2f' % @subtotal
      end
      hash["Descuento"] = '%.2f' % @total_discount if @discount_any
      hash["Moneda"] = 'MXN'
      hash["TipoCambio"] = '1'
      hash["Total"] = '%.2f' % @total
      hash["TipoDeComprobante"] = @type_of_bill_key
      hash["MetodoPago"] = @method_key
      hash["LugarExpedicion"] = b.zipcode
    end

    issuer = Hash.new.tap do |hash|
      hash["Rfc"] = b.rfc
      hash["Nombre"] = e_name_clean
      hash["RegimenFiscal"] = b.tax_regime.tax_id
    end

    receiver = Hash.new.tap do |hash|
      hash["Rfc"] = p_b.rfc
      hash["Nombre"] = r_name_clean unless @general_bill
      hash["UsoCFDI"] = @cfdi_use_key
    end

    total_transfer = Hash.new.tap do |hash|
      hash["Impuesto"] = "002"
      hash["TipoFactor"] = "Tasa"
      if @foreign == true
        hash["TasaOCuota"] = "0.000000"
      else
        hash["TasaOCuota"] = "0.160000"
      end
      if @foreign == true
        hash["Importe"] = '%.2f' % 0
      else
        hash["Importe"] = '%.2f' % @total_taxes
      end
    end
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml['cfdi'].Comprobante(document) do
        unless (@relation_type == '' || @relation_type == 4 )
          xml['cfdi'].CfdiRelacionados('TipoRelacion' => @relation_type ) do
            xml['cfdi'].CfdiRelacionado('UUID' => @bill.uuid)
          end
        end
        xml['cfdi'].Emisor(issuer)
        xml['cfdi'].Receptor(receiver)
        xml['cfdi'].Conceptos do
          @rows.each do |row|
            ## Aquí debo agregar descuento en concepto
            concept = Hash.new.tap do |hash|
              @general_bill ? hash["ClaveProdServ"] = "01010101" : hash["ClaveProdServ"] = row["sat_key"]
              if (@general_bill == true && @relation_type == '')
                hash["NoIdentificacion"] = row["ticket"]
              elsif (@general_bill == false && @relation_type == '')
                hash["NoIdentificacion"] = row["unique_code"]
              end
              @general_bill ? hash["Cantidad"] = "1" : hash["Cantidad"] = row["quantity"]
              @general_bill ? hash["ClaveUnidad"] = "ACT" : hash["ClaveUnidad"] = row["sat_unit_key"]
              hash["Unidad"] = row["sat_unit_description"] unless @general_bill
              @general_bill ? hash["Descripcion"] = "Venta" : hash["Descripcion"] = row["description"]
              if @general_bill
                if @foreign == true
                  hash["ValorUnitario"] = '%.2f' % (row["subtotal"] * 1.16)
                else
                  hash["ValorUnitario"] = '%.2f' % row["subtotal"]
                end
              else
                hash["ValorUnitario"] = '%.2f' % row["unit_value"]
              end
              if @foreign == true
                hash["Importe"] = '%.2f' % (row["subtotal"] * 1.16)
              else
                hash["Importe"] = '%.2f' % row["subtotal"]
              end
              hash["Descuento"] = '%.2f' % row["discount"] unless row["discount"] == 0
            end
            transfer = Hash.new.tap do |hash|
              if @foreign == true
                hash["Base"] = '%.2f' % ((row["subtotal"] - row["discount"]) * 1.16)
              else
                hash["Base"] = '%.2f' % (row["subtotal"] - row["discount"])
              end
              hash["Impuesto"] = "002"
              hash["TipoFactor"] = "Tasa"

              if @foreign == true
                hash["TasaOCuota"] = "0.000000"
              else
                hash["TasaOCuota"] = "0.160000"
              end
              if @foreign == true
                hash["Importe"] = '%.2f' % (row["taxes"] * 0)
              else
                hash["Importe"] = '%.2f' % row["taxes"]
              end
            end
            xml['cfdi'].Concepto(concept) do
              xml['cfdi'].Impuestos do
                xml['cfdi'].Traslados do
                  xml['cfdi'].Traslado(transfer)
                end
              end
            end
          end
        end
        if @foreign == true
          xml['cfdi'].Impuestos('TotalImpuestosTrasladados'=> 0.00) do
            xml['cfdi'].Traslados do
              xml['cfdi'].Traslado(total_transfer)
            end
          end
        else
          xml['cfdi'].Impuestos('TotalImpuestosTrasladados'=> @total_taxes) do
            xml['cfdi'].Traslados do
              xml['cfdi'].Traslado(total_transfer)
            end
          end
        end
      end
    end
    builder.to_xml.encoding
    unsigned = File.open(File.join(@working_dir, 'unsigned.xml'), 'w'){ |file| file.write(builder.to_xml) }
  end

  def generate_digital_stamp
    # Crea un archivo sign.bin en blanco para la información del sello
    sign = File.open(File.join(@working_dir, 'sign.bin'), 'w'){ |file| file.write('') }

    # Lee el XML creado, lo procesa con el archivo XSLT del SAT y lo guarda en un archivo
    xml = Nokogiri::XML(File.read(@working_path.join('unsigned.xml')))
    xslt = Nokogiri::XSLT(File.read(@sat_path.join('cadenaoriginal_3_3.xslt')))
    original_chain = xslt.apply_to(xml)
    orig = File.open(File.join(@working_dir, 'original_chain.txt'), 'w'){ |file| file.write(original_chain) }

    # Lee los archivos necesarios para el proceso
    bin = @working_path.join('sign.bin')
    original = @working_path.join('original_chain.txt')
    new_pem = @store_path.join("key", "new_key.pem")
    @original = File.read(original).delete("\n")

    # Ejecuta el proceso de encriptado con SHA256 y lo guarda en el archivo bin
    `openssl dgst -sha256 -out "#{bin}" -sign "#{new_pem}" "#{original}"`

    # Crea y lee un archivo en blanco para guardar el sello digital
    stmp = File.open(File.join(@working_dir, 'stamp.txt'), 'w'){ |file| file.write('') }
    stamp = @working_path.join('stamp.txt')

    # Ejecuta el proceso de sello digital y lo guarda en el archivo
    `openssl enc -in "#{bin}" -a -A -out "#{stamp}"`

    stamp_value = File.read(@working_path.join('stamp.txt'))
    xml.xpath('cfdi:Comprobante').attribute('Sello').value = stamp_value

    certificate = @store.certificate_content
    xml.xpath('cfdi:Comprobante').attribute('Certificado').value = certificate
    unstamped = File.open(File.join(@working_dir, 'unstamped.xml'), 'w'){ |file| file.write(xml.to_xml) }
  end

  def cancel_uuid
    #Crea un cliente SOAP con Savon
    client = Savon.client(wsdl: ENV['cancel_dir'])

    username = ENV['username_pac'] # Usuario de Finkok
    password = ENV['password_pac'] # Password de Finkok
    taxpayer_id = @bill.issuing_company.rfc #RFC Emisor
    invoices = @bill.uuid #UUID a cancelar

    # Lee el archivo Cer en formato Pem ".cer"

    cer_pem_b64 = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cerb64.cer.pem"))

    key_des3_b64 = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "keyb64.enc.key"))

    uuid = [invoices]
    uuid.map! do |uuid|
      uuid = "<tns:string>#{uuid}</tns:string>"
    end

xml = <<XML
  <tns:UUIDS>
    <tns:uuids>
      #{uuid.join "\n"}
    </tns:uuids>
  </tns:UUIDS>
  <tns:username>#{username}</tns:username>
  <tns:password>#{password}</tns:password>
  <tns:taxpayer_id>#{taxpayer_id}</tns:taxpayer_id>
  <tns:cer>#{cer_pem_b64}</tns:cer>
  <tns:key>#{key_des3_b64}</tns:key>
XML

    #Obtiene el SOAP Request y lo guarda en un archivo
    ops = client.operation(:cancel)
    request = ops.build(message: xml)

    #Envia la peticion al webservice de cancelacion
    response = client.call(:cancel, message: xml)
    response_hash = response.hash
    receipt = response_hash[:envelope][:body][:cancel_response][:cancel_result][:acuse]

    xml_receipt = Nokogiri::XML(receipt)

    @cancel_status = response_hash[:envelope][:body][:cancel_response][:cancel_result][:cod_estatus] # Si es exitoso debe ser nil

    receipt_extract = xml_receipt.document.children.children.children

    receipt_file = File.open(File.join(@final_dir, 'acuse.xml'), 'w'){ |file| file.write(xml_receipt) }

#    soap_response = File.open(File.join(@working_dir, 'response.xml'), 'w'){ |file| file.write(response) }

    soap_request = File.open(File.join(@working_dir, 'request.xml'), 'w'){ |file| file.write(request) }

    @receipt_file = File.open(File.join(@final_dir, 'acuse.xml'), 'r')

    if (@cancel_status == '201' || @cancel_status == nil)
      validate_payed(@bill)
      @bill.update(cancel_receipt: @receipt_file, status: 'cancelada')
      redirect_to root_path, notice: "Se ha cancelado exitosamente la factura con Folio #{@bill.folio}."
    else
      redirect_to root_path, alert: "Hubo un error al intentar cancelar, por favor intente de nuevo."
    end

  end

  #### ESTE MÉTODO ES PARA BILL ### ##CAMBIAR POR MÉTODO PARA SOLO TIMBRE FISCAL SIN SELLO#
  def get_stamp_from_pac
    #Crea un cliente SOAP con Savon
    client = Savon.client(wsdl: ENV['stamp_dir'])

    #Carga el XML para ser timbrado
    file = File.read(@working_path.join('unstamped.xml')) ## CAMBIAR A UNSTAMPED CUANDO SEAN EXITOSAS LAS PRUEBAS

    #Cifra el XML en Base64
    xml_file = Base64.encode64(file.delete("\n"))

    #Correo y contraseña de acceso al panel de FINKOK
    username = ENV['username_pac']
    password = ENV['password_pac']
    #Envia la peticion al webservice de timbrado

    ops = client.operation(:stamp) ##CAMBIAR A STAMP CUANDO SEAN EXITOSAS LAS PRUEBAS
    request = ops.build(message: { xml: xml_file, username: username , password: password })

    #Obtiene el SOAP Request y lo guarda en un archivo
    response = client.call(:stamp, message: { xml: xml_file, username: username , password: password })
    response_hash = response.hash

    #Obtiene el SOAP Request y guarda la respuesta en un archivo
    soap_request = File.open(File.join(@working_dir, 'SOAP_Reques_STATUS.xml'), 'w') do |file|
      file.write(request)
    end

    #Obtiene el SOAP Response y guarda la respuesta en un archivo
    soap_response = File.open(File.join(@working_dir, 'SOAP_Response_STATUS'), 'w') do |file|
      file.write(response_hash)
    end

    # Resume el método para llamar las distintas partes del hash del webservice
    hash = response_hash[:envelope][:body][:stamp_response][:stamp_result]

    #Separa los métodos según las partes que se necesitan
    xml_response = hash[:xml]
    @uuid = hash[:uuid]
    @date_response = hash[:fecha]
    @cod_status = hash[:cod_estatus]
    @sat_seal = hash[:sat_seal]
    @sat_certificate = hash[:no_certificado_sat]
    @incidents_hash = hash[:incidencias]

    if @cod_status == 'Comprobante timbrado satisfactoriamente'
      incidents = File.open(File.join(@working_dir, 'incidencias.txt'), 'w'){ |file| file.write(@incidents_hash) }

      #Separa la parte del timbre fiscal digital para generar cadena original (y quita la parte que genera error)
      doc = Nokogiri::XML(xml_response)

      if @pay_bill
        extract = doc.xpath('//cfdi:Complemento').children[1]
      else
        extract = doc.xpath('//cfdi:Complemento').children.to_xml.gsub('xsi:', '')
      end

      #Obtiene el atributo SelloCFD
      if @pay_bill
        @cfd_stamp = doc.xpath('//cfdi:Complemento').children[1].attr('SelloCFD')
      else
        @cfd_stamp = doc.xpath('//cfdi:Complemento').children.attr('SelloCFD').value
      end

      #Obtiene los últimos 8 dígitos del atributo SelloCFD (para QR)
      @cfd_last_8 = @cfd_stamp.slice((@cfd_stamp.length - 8)..@cfd_stamp.length)

      #Guarda en XML el archivo timbrado del PAC
      ###### CAMBIAR ESTE MÉTODO POR UN NOMBRE DISTITNO DE FACTURA
      stamped_xml = File.open(File.join(@final_dir, 'stamped.xml'), 'w'){ |file| file.write(xml_response) }

      @stamped_xml = File.open(File.join(@final_dir, 'stamped.xml'), 'r')

      xml_url = @xml_path + 'stamped.xml' ###### CAMBIAR ESTE MÉTODO POR UN NOMBRE DISTITNO DE FACTURA

      #Guarda el extracto del timbre fiscal digital en un XML
      extract_xml = File.open(File.join(@working_dir, 'tfd.xml'), 'w'){ |file| file.write(extract) }

      #Transforma el XML del timbre fiscal digital en una cadena original usando el xslt del SAT
      stamp_xml = Nokogiri::XML(File.read(@working_path.join('tfd.xml')))
      stamp_xslt = Nokogiri::XSLT(File.read(@sat_path.join('cadenaoriginal_TFD_1_1.xslt')))
      @stamp_original_chain = stamp_xslt.apply_to(stamp_xml)
    end
  end

  def save_to_db
    @error = false
    @pdf_file = File.open(File.join(@final_dir, 'factura.pdf'), 'r')
    bill = Bill.new.tap do |bill|
      bill.status = 'creada'
      if @pay_bill
        bill.issuing_company = @store.business_unit.billing_address
        bill.receiving_company = Prospect.find(@prospect).billing_address
      else
        bill.issuing_company = @s_billing
        bill.receiving_company = @p_billing
      end
      @prospect.class == Fixnum ? bill.prospect_id = @prospect : bill.prospect = @prospect
      bill.store = @store
      bill.sequence = @series
      bill.folio = @folio
      bill.payment_conditions = @payment_form
      bill.payment_method = @method
      bill.payment_form = @greatest_payment
      bill.subtotal = @subtotal.to_f
      bill.taxes = @total_taxes.to_f
      bill.total = @total.to_f
      bill.discount_applied = @total_discount.to_f
      # bill.automatic_discount_applied = @total_discount
      # bill.manual_discount_applied = @total_discount
      bill.tax = Tax.find(2)
      bill.tax_regime = @regime
      bill.taxes_transferred = @total_taxes.to_f
      # bill.taxes_witheld =
      bill.cfdi_use = @use
      # bill.pac =
      bill.relation_type = @relation
      # bill.references_field = ''
      bill.type_of_bill = @bill_type
      bill.currency = Currency.find_by_name('MXN')
      # bill.id_trib_reg_num = ''
      # bill.confirmation_key =
      bill.exchange_rate = 1.0
      bill.country = Country.find_by_name('México')
      bill.sat_certificate_number = @sat_certificate
      bill.certificate_number = @store.certificate_number
      bill.qr_string = @qr_string
      bill.original_chain = @stamp_original_chain
      bill.sat_stamp = @sat_seal
      bill.digital_stamp = @cfd_stamp
      bill.sat_zipcode_id = SatZipcode.find_by_zipcode(@store.zip_code)
      bill.date_signed = @date
      bill.leyend = ''
      bill.uuid = @uuid
      bill.payed = @payed
      if @objects != nil
        @objects.class == Bill ? bill.from = @bill.class.to_s : bill.from = @objects.first.class.to_s
      else
        @pay_bill ? bill.from = 'Payments' : bill.from = 'Form'
      end
        @general_bill == true ? bill.bill_type = 'global' : bill.bill_type = 'cliente'
      bill.parent = @bill
      if @pay_bill
        bill.bill_folio_type = "Pago"
      else
        if @relation&.id == 1
          bill.bill_folio_type = "Nota de Crédito"
        elsif @relation&.id == 2
          bill.bill_folio_type = "Nota de Débito"
        elsif @relation&.id == 3
          bill.bill_folio_type = "Devolución"
        elsif @relation&.id == 4
          bill.bill_folio_type = "Sustitución"
        elsif @relation&.id == 7
          bill.bill_folio_type = "Aplicación de Anticipo"
        elsif @series.include?("FA")
          bill.bill_folio_type = "Anticipo"
        else
          bill.bill_folio_type = "Factura"
        end
      end
    end
    if @bill == nil
      if @pay_bill
        @store.update(pay_bill_last_folio: @folio)
      else
        @store.update(bill_last_folio: @folio)
      end
    else
      if @relation_type == '01'
        @store.update(credit_note_last_folio: @folio)
      elsif @relation_type == '02'
        @store.update(debit_note_last_folio: @folio)
      elsif @relation_type == '03'
        @store.update(return_last_folio: @folio)
      elsif @relation_type == '07'
        @store.update(advance_e_last_folio: @folio)
      else
        @store.update(bill_last_folio: @folio)
      end
    end
    if bill.save
      if @bill != nil
        @bill.children << bill
      end
      if @bill == nil && !@pay_bill || @relation_type == '04'
        @rows.each do |row|
          row_for_bill = Row.new.tap do |r|
            r.bill = bill
            r.product = row["product_id"]
            r.service = row["service_id"]
            r.unique_code = row["unique_code"]
            r.quantity = row["quantity"]
            r.description = row["description"]
            r.unit_value = row["unit_value"]
            r.sat_unit_key = row["sat_unit_key"]
            r.sat_unit_description = row["sat_unit_description"]
            r.sat_key = row["sat_key"]
            r.ticket = row["ticket"]
            r.total = row["total"]
            r.subtotal = row["subtotal"]
            r.discount = row["discount"]
            r.taxes = row["taxes"]
          end
          row_for_bill.save
        end
      else
        if !@pay_bill
          @rows.each do |row|
            row.update(bill: bill)
          end
        end
      end
      # El update de folio solo sirve para las facturas normales por el momento
      bill.update(xml: @stamped_xml, pdf: @pdf_file)
      if @objects != nil
        if @objects.is_a?(Array) || @objects.is_a?(ActiveRecord::Relation)
          @objects.each do |object|
            object.update(bill: bill)
            object.payments.each do |payment|
              payment.update(bill: bill) if bill.bill_folio_type != 'Pago'
            end
            if object.is_a?(Ticket)
              object.store_movements.each do |mov|
                mov.update(bill: bill)
              end
              object.service_offereds.each do |serv|
                serv.update(bill: bill)
              end
              object.children.each do |ticket|
                ticket.payments.each do |payment|
                  payment.update(bill: bill)
                end
                ticket.update(bill: bill)
                ticket.store_movements.each do |mov|
                  mov.update(bill: bill)
                end
                ticket.service_offereds.each do |serv|
                  serv.update(bill: bill)
                end
              end
            elsif object.is_a?(Order)
              object.movements.each do |mov|
                mov.update(bill: bill)
              end
              object.pending_movements.each do |mov|
                mov.update(bill: bill)
              end
              object.service_offereds.each do |serv|
                serv.update(bill: bill)
              end
            end
          end
        end
      end
      if @pay_bill
        @rows.each do |row|
          Bill.find(row[12]).update(pay_bill: bill)
          Payment.find(row[10]).update(payment_bill: bill)
        end
      else
        bill.parent == nil ? validate_payed(bill) : validate_payed(bill.parent)
      end
    else
      @error = true
    end
  end

  def rows(general_bill, objects)
    @rows = []
    if (general_bill == true && objects.first.is_a?(Ticket))
      objects.each do |o|
        new_hash = Hash.new.tap do |hash|
          hash["ticket"] = ''
          hash["quantity"] = '1'
          hash["unit_value"] = 0
          hash["sat_key"] = '01010101'
          hash["sat_unit_key"] = 'ACT'
          hash["description"] = 'Venta'
          hash["total"] = 0
          hash["subtotal"] = 0
          hash["taxes"] = 0
          hash["discount"] = 0
        end
        new_hash["ticket"] = o.ticket_number
        if @foreign == true
          new_tax = ((o.subtotal.round(2) - o.discount_applied).round(2) * 0.16).round(2)
          tax_number = 0
          new_hash["total"] += (o.subtotal.round(2) - o.discount_applied.round(2) + new_tax).round(2) unless o.total == nil
          new_hash["taxes"] += 0 unless o.taxes == nil
          new_hash["subtotal"] += (o.subtotal * 1.16).round(2) unless o.subtotal == nil
        else
          tax_number = 0.16
          new_tax = ((o.subtotal.round(2) - o.discount_applied).round(2) * 0.16).round(2)
          new_hash["total"] += (o.subtotal.round(2) - o.discount_applied.round(2) + new_tax).round(2) unless o.total == nil
          new_hash["taxes"] += new_tax unless o.taxes == nil
          new_hash["subtotal"] += o.subtotal.round(2) unless o.subtotal == nil
        end
        new_hash["unit_value"] += o.subtotal.round(2) unless o.subtotal == nil
        new_hash["discount"] += o.discount_applied.round(2) unless o.discount_applied == nil
        o.children.each do |children|
          if children.ticket_type == 'devolución'
            new_tax_child = ((children.subtotal.round(2) - children.discount_applied.round(2)).round(2) * tax_number).round(2)
            new_hash["total"] -= (children.subtotal.round(2) - children.discount_applied.round(2) + new_tax_child).round(2) unless children.total == nil
            new_hash["subtotal"] -= children.subtotal.round(2) unless children.subtotal == nil
            new_hash["taxes"] -= new_tax_child unless children.taxes == nil
            new_hash["discount"] -= children.discount_applied.round(2) unless children.discount_applied == nil
          end
        end
        @rows << new_hash
      end
    elsif (general_bill == false && objects.first.is_a?(Ticket))
      objects.each do |o|
        o.store_movements.each do |sm|
          new_hash = Hash.new.tap do |hash|
            hash["product_id"] = ''
            hash["unique_code"] = ''
            hash["quantity"] = 0
            hash["unit_value"] = 0
            hash["ticket"] = ''
            hash["sat_key"] = ''
            hash["sat_unit_key"] = ''
            hash["description"] = ''
            hash["total"] = 0
            hash["subtotal"] = 0
            hash["taxes"] = 0
            hash["discount"] = 0
          end
          new_hash["product_id"] = sm.product.id
          new_hash["ticket"] = sm.ticket.id
          new_hash["quantity"] = sm.quantity
          new_hash["unit_value"] = sm.initial_price.round(2)
          new_hash["sat_key"] = sm.product.sat_key.sat_key
          new_hash["sat_unit_key"] = sm.product.sat_unit_key.unit
          new_hash["sat_unit_description"] = sm.product.sat_unit_key.description
          new_hash["description"] = sm.product.description.capitalize
          new_hash["unique_code"] = sm.product.unique_code
          new_hash["total"] = sm.total.round(2)
          new_hash["subtotal"] = sm.subtotal.round(2)
          new_hash["taxes"] = sm.taxes.round(2)
          sm.discount_applied == nil ? new_hash["discount"] = 0 : new_hash["discount"] = sm.discount_applied.round(2)
          @rows << new_hash
        end
        o.service_offereds.each do |so|
          new_hash = Hash.new.tap do |hash|
            hash["service_id"] = ''
            hash["unique_code"] = ''
            hash["quantity"] = 0
            hash["unit_value"] = 0
            hash["ticket"] = ''
            hash["sat_key"] = ''
            hash["sat_unit_key"] = ''
            hash["description"] = ''
            hash["total"] = 0
            hash["subtotal"] = 0
            hash["taxes"] = 0
            hash["discount"] = 0
          end
          new_hash["service_id"] = so.service.id
          new_hash["ticket"] = so.ticket.id
          new_hash["quantity"] = so.quantity
          new_hash["unit_value"] = so.initial_price.round(2)
          new_hash["sat_key"] = so.service.sat_key.sat_key
          new_hash["sat_unit_key"] = so.service.sat_unit_key.unit
          new_hash["sat_unit_description"] = so.service.sat_unit_key.description
          new_hash["description"] = so.service.description.capitalize
          new_hash["unique_code"] = so.service.unique_code
          new_hash["total"] = so.total.round(2)
          new_hash["subtotal"] = so.subtotal.round(2)
          new_hash["taxes"] = so.taxes.round(2)
          so.discount_applied == nil ? new_hash["discount"] = 0 : new_hash["discount"] = so.discount_applied.round(2)
          @rows << new_hash
        end
        o.children.each do |children|
          children.store_movements.each do |sm|
            product = sm.product.unique_code
            ticket = sm.ticket.parent.id
            i = ''
            @rows.each_with_index do |key, index|
              i = index if (key["unique_code"] == product)
            end
            if i == ''
              new_hash = Hash.new.tap do |hash|
                hash["product_id"] = ''
                hash["unique_code"] = ''
                hash["quantity"] = 0
                hash["unit_value"] = 0
                hash["ticket"] = ''
                hash["sat_key"] = ''
                hash["sat_unit_key"] = ''
                hash["description"] = ''
                hash["total"] = 0
                hash["subtotal"] = 0
                hash["taxes"] = 0
                hash["discount"] = 0
              end
              new_hash["product_id"] = sm.product.id
              new_hash["ticket"] = sm.ticket.id
              new_hash["quantity"] = sm.quantity
              new_hash["unit_value"] = sm.initial_price.round(2)
              new_hash["sat_key"] = sm.product.sat_key.sat_key
              new_hash["sat_unit_key"] = sm.product.sat_unit_key.unit
              new_hash["sat_unit_description"] = sm.product.sat_unit_key.description
              new_hash["description"] = sm.product.description.capitalize
              new_hash["unique_code"] = sm.product.unique_code
              new_hash["total"] = sm.total.round(2)
              new_hash["subtotal"] = sm.subtotal.round(2)
              new_hash["taxes"] = sm.taxes.round(2)
              sm.discount_applied == nil ? new_hash["discount"] = 0 : new_hash["discount"] = sm.discount_applied.round(2)
              @rows << new_hash
            else
              @rows[i]["quantity"] -= sm.quantity
              @rows[i]["total"] -= sm.total.round(2)
              @rows[i]["subtotal"] -= sm.subtotal.round(2)
              @rows[i]["taxes"] -= sm.taxes.round(2)
              @rows[i]["discount"] -= sm.discount_applied.round(2)
            end
          end
          children.service_offereds.each do |so|
            serv = so.service.unique_code
            ticket = so.ticket.parent.id
            i = ''
            @rows.each_with_index do |key, index |
              i = index if (key["unique_code"] == serv)
            end
            if i == ''
              new_hash = Hash.new.tap do |hash|
                hash["service_id"] = ''
                hash["unique_code"] = ''
                hash["quantity"] = 0
                hash["unit_value"] = 0
                hash["ticket"] = ''
                hash["sat_key"] = ''
                hash["sat_unit_key"] = ''
                hash["description"] = ''
                hash["total"] = 0
                hash["subtotal"] = 0
                hash["taxes"] = 0
                hash["discount"] = 0
              end
              new_hash["service_id"] = sm.service.id
              new_hash["ticket"] = so.ticket.id
              new_hash["quantity"] = so.quantity
              new_hash["unit_value"] = so.initial_price.round(2)
              new_hash["sat_key"] = so.service.sat_key.sat_key
              new_hash["sat_unit_key"] = so.service.sat_unit_key.unit
              new_hash["sat_unit_description"] = so.service.sat_unit_key.description
              new_hash["description"] = so.service.description.capitalize
              new_hash["unique_code"] = so.service.unique_code
              new_hash["total"] = so.total.round(2)
              new_hash["subtotal"] = so.subtotal.round(2)
              new_hash["taxes"] = so.taxes.round(2)
              so.discount_applied == nil ? new_hash["discount"] = 0 : new_hash["discount"] = so.discount_applied.round(2)
              @rows << new_hash
            else
              @rows[i]["quantity"] -= so.quantity
              @rows[i]["total"] -= so.total.round(2)
              @rows[i]["subtotal"] -= so.subtotal.round(2)
              @rows[i]["taxes"] -= so.taxes.round(2)
              @rows[i]["discount"] -= so.discount_applied.round(2)
            end
          end
        end
        blank_rows_indices = []
        @rows.each_with_index{ |key, index | blank_rows_indices << index if key["quantity"] == 0 }
        blank_rows_indices.each do |i|
          @rows.delete_at(i)
        end
      end
      # Falta ver si agrego un código para agrupar sin tener que coincidir el ticket
    elsif (general_bill == true && objects.first.is_a?(Order))
      objects.each do |o|
        new_hash = Hash.new.tap do |hash|
          hash["ticket"] = ''
          hash["quantity"] = '1'
          hash["unit_value"] = 0
          hash["sat_key"] = '01010101'
          hash["sat_unit_key"] = 'ACT'
          hash["description"] = 'Venta'
          hash["total"] = 0
          hash["subtotal"] = 0
          hash["taxes"] = 0
          hash["discount"] = 0
        end
        new_hash["ticket"] = o.id
        new_hash["total"] += o.total.round(2) unless o.total == nil
        new_hash["unit_value"] += o.subtotal.round(2) unless o.subtotal == nil
        new_hash["subtotal"] += o.subtotal.round(2) unless o.subtotal == nil
        new_hash["taxes"] += o.taxes.round(2) unless o.taxes == nil
        new_hash["discount"] += o.discount_applied.round(2) unless o.discount_applied == nil
        @rows << new_hash
      end
    else
      objects.each do |o|
        o.product_requests.where.not(status: 'cancelada').each do |pr|
          pr.movements.each do |mov|
            new_hash = Hash.new.tap do |hash|
              hash["product_id"] = ''
              hash["unique_code"] = ''
              hash["quantity"] = 0
              hash["unit_value"] = 0
              hash["ticket"] = ''
              hash["sat_key"] = ''
              hash["sat_unit_key"] = ''
              hash["description"] = ''
              hash["total"] = 0
              hash["subtotal"] = 0
              hash["taxes"] = 0
              hash["discount"] = 0
            end
            new_hash["product_id"] = mov.product.id
            new_hash["ticket"] = mov.order.id
            mov.product.group ? new_hash["quantity"] = mov.kg * mov.quantity.to_i : new_hash["quantity"] = mov.quantity.to_i
            new_hash["unit_value"] = mov.initial_price.round(2)
            new_hash["sat_key"] = mov.product.sat_key.sat_key
            new_hash["sat_unit_key"] = mov.product.sat_unit_key.unit
            new_hash["sat_unit_description"] = mov.product.sat_unit_key.description
            new_hash["description"] = mov.product.description.capitalize
            new_hash["unique_code"] = mov.product.unique_code
            new_hash["total"] = mov.total.round(2)
            new_hash["subtotal"] = mov.subtotal.round(2)
            new_hash["taxes"] = mov.taxes.round(2)
            new_hash["discount"] += mov.discount_applied.round(2) unless mov.discount_applied == nil
            @rows << new_hash
          end
          mov = pr.pending_movement
          if mov != nil
            new_hash = Hash.new.tap do |hash|
              hash["product_id"] = ''
              hash["unique_code"] = ''
              hash["quantity"] = 0
              hash["unit_value"] = 0
              hash["ticket"] = ''
              hash["sat_key"] = ''
              hash["sat_unit_key"] = ''
              hash["description"] = ''
              hash["total"] = 0
              hash["subtotal"] = 0
              hash["taxes"] = 0
              hash["discount"] = 0
            end
            new_hash["product_id"] = mov.product.id
            new_hash["ticket"] = mov.order.id
            mov.product.group ? new_hash["quantity"] = mov.product.average * mov.quantity : new_hash["quantity"] = mov.quantity
            new_hash["unit_value"] = mov.initial_price.round(2)
            new_hash["sat_key"] = mov.product.sat_key.sat_key
            new_hash["sat_unit_key"] = mov.product.sat_unit_key.unit
            new_hash["sat_unit_description"] = mov.product.sat_unit_key.description
            new_hash["description"] = mov.product.description.capitalize
            new_hash["unique_code"] = mov.product.unique_code
            if mov.product.group
              new_hash["subtotal"] = (mov.subtotal * mov.quantity).round(2)
              new_hash["discount"] = ('%.2f' % ('%.2f' % (mov.initial_price - mov.final_price)).to_f).to_f * mov.quantity * mov.product.average unless mov.discount_applied == nil
              taxes = ('%.2f' % ((new_hash["subtotal"].round(2) - new_hash["discount"].round(2)) * 0.16)).to_f
              new_hash["total"] = new_hash["subtotal"].round(2) - new_hash["discount"] + taxes
            else
              new_hash["subtotal"] = (mov.subtotal * new_hash["quantity"]).round(2)
              new_hash["discount"] = (('%.2f' % (mov.initial_price - mov.final_price)).to_f * new_hash["quantity"]).round(2) unless mov.discount_applied == nil
              taxes = ( ('%.2f' % (mov.subtotal - ('%.2f' % (mov.initial_price - mov.final_price)).to_f)).to_f * new_hash["quantity"] * 0.16).round(2)
              new_hash["total"] = new_hash["subtotal"].round(2) - new_hash["discount"] + taxes
            end
            new_hash["taxes"] = taxes
            @rows << new_hash
          end
        end
      end
    end
    @rows
  end

  def get_prospect_from_objects(object)
    object_prospect = []
    if object.first.is_a?(Bill)
      object.each do |object|
        object_prospect << object.receiving_company unless object.receiving_company == nil
      end
    else
      object.each do |object|
        object_prospect << object.prospect unless object.prospect == nil
      end
      object_prospect.uniq.length == 1 ? @prospect = object_prospect.first : @prospect = nil
      @prospect
    end
  end

  def get_cfdi_use_from_tickets(tickets)
    ticket_cfdi_use = []
    tickets.each do |ticket|
      ticket_cfdi_use << ticket.cfdi_use unless ticket.cfdi_use == nil
    end
    ticket_cfdi_use.uniq.length == 1 ? @cfdi_use = ticket_cfdi_use.first : @cfdi_use = nil
    @cfdi_use
  end

  def qrcode
    site = 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx'
    id = @uuid
    emisor = @store_rfc
    receptor = @prospect_rfc
    total = @total.round(2).to_s
    sello = @cfd_last_8
    qr = site + '?id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello
    @qr_string = qr
  end

  def qrcode_print
    qrcode
    @qr_print = RQRCode::QRCode.new( (@qr_string),  :size => 13, :level => :h )
  end

# NOTAS PARA XML:
  # En el caso del & se debe usar la secuencia &amp;
  # En el caso del “ se debe usar la secuencia &quot;
  # En el caso del < se debe usar la secuencia &lt;
  # En el caso del > se debe usar la secuencia &gt;
  # En el caso del ‘ se debe usar la secuencia &apos;

# Para este método se necesita concatenar los siguientes elementos, iniciando y terminando con || y separados por un | (sin espacios):
  #  1. Version
  #  2. UUID
  #  3. FechaTimbrado
  #  4. RfcProvCertif
  #  5. Leyenda (el SAT puede poner cualquier cosa aquí)
  #  6. SelloCFD
  #  7. NoCertificadoSAT

# Ó también generarla a través de xslt, ejemplo:  ||1.1|ad662d33-6934-459c-a128-bdf0393e0f44|2001-12-17T09:30:47|AAA010802QT9|ValorDelAtributoLeyenda|iYyIk1MtEPzTxY3h57kYJnEXNae9lvLMgAq3jGMePsDtEOF6XLWbrV2GL/2TX00vP2+YsPN+5UmyRdzMLZGEfESiNQF9fotNbtA487dWnCf5pUu0ikVpgHvpY7YoA4Lb1D/JWc+zntkgW+Ig49WnlKyXi0LOlBOVuxckDb7Eax4=|12345678901234567890||

  def generate_pdf
    if @pay_bill
      pdf = render_to_string pdf: "REP", template: 'bills/payment_doc', page_size: 'Letter', layout: 'bill.html', encoding: "UTF-8"
    else
      if @general_bill
        pdf = render_to_string pdf: "factura", template: 'bills/global_doc', page_size: 'Letter', layout: 'bill.html', encoding: "UTF-8"
      else
        pdf = render_to_string pdf: "factura", template: 'bills/doc', page_size: 'Letter', layout: 'bill.html', encoding: "UTF-8"
      end
    end
    save_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@unchanged_time}-#{@p_rfc}_final", 'factura.pdf')
    pdf_bill = File.open(save_path, 'wb'){ |file| file << pdf }
    @pdf = pdf_bill
  end

  def doc
    preview
    rows
    subtotal
    total_taxes
    total
    qrcode
    ### REVISAR PARA OTRO TIPO DE FACTURAS ###
    filename = "fact_#{current_user.store.series}_#{current_user.store.last_bill.next}_#{Prospect.find(params[:prospect]).billing_address.rfc}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'bill.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def payment_doc
    qrcode
    filename = "REP_#{current_user.store.series}_#{current_user.store.last_bill.next}_#{Prospect.find(@prospect).billing_address.rfc}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/payment_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'bill.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def global_doc
    preview
    rows
    subtotal
    total_taxes
    total
    global_qrcode
    ### REVISAR PARA OTRO TIPO DE FACTURAS ###
    filename = "fact_#{current_user.store.series}_#{current_user.store.last_bill.next}_#{Prospect.find(params[:prospect]).billing_address.rfc}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/global_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'bill.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)
    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(
      :status,
      :order_id,
      :initial_price,
      :discount_applied,
      :automatic_discount_applied,
      :manual_discount_applied,
      :price_before_taxes,
      :type_of_bill,
      :prospect_id,
      :classification,
      :amount,
      :quantity,
      :pdf,
      :xml,
      :cancel_receipt,
      :issuing_company_id,
      :receiving_company_id,
      :store_id,
      :sequence,
      :folio,
      :expedition_zip_id,
      :payment_conditions,
      :payment_method_id,
      :payment_form_id,
      :tax_regime_id,
      :cfdi_use_id,
      :tax_id,
      :pac_id,
      :fiscal_folio,
      :digital_stamp,
      :sat_stamp,
      :original_chain,
      :relation_type_id,
      :child_bills_id,
      :parent_id,
      :references_field,
      :type_of_bill_id,
      :certificate,
      :currency_id,
      :fiscal_residency_id,
      :id_trib_reg_num,
      :confirmation_key,
      :exchange_rate,
      :country_id,
      :taxes_trasnferred,
      :taxes_witheld,
      :payments,
      :payment_form,
      :image,
      :total_payment,
      :date
      )
    end
end
