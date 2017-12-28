class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :bill, :bill_doc, :update, :destroy, :download_pdf, :download_xml, :download_xml_receipt]

  require 'rqrcode'
  require 'savon'
  require 'base64'

  # GET /bills@type_of_bill
  # GET /bills.json
  def index
    store = current_user.store
    @bills = store.bills.where.not(status: 'cancelada').where.not(receiving_company: nil).where.not(total: nil).where(parent: nil)
  end

  # GET /bills/1
  # GET /bills/1.json
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
  end

  def details_global
    @bill = Bill.find(params[:bill])
  end

  def select_action
  end

  def issued
    store = Store.find(params[:store]) || current_user.store
    month = params[:month]
    year = params[:year]
    @bills = store.bills.where('extract(month from created_at) = ? and extract(year from created_at) = ?', month, year).where(relation_type: nil).where.not(pdf: nil, xml: nil)
  end

  def select_bills
    store = current_user.store
    @bills = store.bills.where.not(status: 'cancelada').where.not(receiving_company: nil).where.not(total: nil).where(parent: nil)
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
      @zipcode = [store.business_unit.billing_address.zipcode, store.id]
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
        @zipcode = [store.business_unit.billing_address.zipcode, store.id]
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
      prospects = @store.prospects
    else
      prospects = Prospect.joins(:billing_address).joins(:business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
    prospects.each do |prospect|
      if prospect.billing_address != nil
        @prospects_names << [prospect.billing_address.business_name, prospect.id]
        @prospects_rfcs << [prospect.billing_address.rfc, prospect.id]
      end
    end
    global = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno').first
    @global_id = global.id
    @global_rfc = global.billing_address.rfc

    @prospects_rfcs << [global.billing_address.rfc, global.id]
    @prospects_names << [global.billing_address.business_name, global.id]
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
    select_prospects_info
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
    @products.each do |product|
      @products_ids << [product.id]
      @products_codes << [product.unique_code, product.id]
      @products_description << [product.description, product.id]
      @products_sat_keys << [product.sat_key.sat_key, product.id]
      @products_sat_unit_keys << [product.sat_unit_key.unit, product.id]
      @products_units << [product.sat_unit_key.description, product.id]
      if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
        @products_prices << [(product.price * (1 + (@store.overprice.to_f / 100))).round(2), product.id]
      else
        @products_prices << [(product.price * (1 + (@stores.first.overprice.to_f / 100))).round(2), product.id]
      end
    end
  end

  def filter_sat_keys
  end

  def filter_sat_unit_keys
  end

  def filter_sat_unit
  end

  def filter_description
  end

  def form
    get_info_for_form
    filter_product_options
  end

  def global_form
    get_info_for_form
    filter_product_options
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
    @orders = Order.where.not(status: 'entregada').where(bill: nil)
    # Cambiar cuando reestructure la información
  end

  def select_info
    params[:tickets] == nil ? @tickets = nil : @tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? @orders = nil : @orders = Order.find(params[:orders])
    params[:bills] == nil ? @bills = nil : @bills = Bill.find(params[:bills])
    if (@tickets == nil  && @orders == nil)
      objects = @bills
    elsif (@tickets == nil && @bills == nil)
      objects = @orders
    elsif (@bills == nil  && @orders == nil)
      objects = @tickets
    end
    if objects.first.is_a?(Ticket)
      get_cfdi_use_from_tickets(@tickets)
    elsif objects.first.is_a?(Order)
      @cfdi_use = CfdiUse.first
    else
      @cfdi_use = nil
    end
    get_prospect_from_objects(objects)
    @type_of_bill = TypeOfBill.first
    @tickets = params[:tickets] unless params[:tickets] == nil
    @orders = params[:orders] unless params[:orders] == nil
  end

  def global_preview
  end

  def preview
    @relation_type = params[:relation_type]
    params[:bill] == nil ? @bill = nil : @bill = Bill.find(params[:bill])
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    if @bill != nil
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
      cancel_uuid
    else
      if tickets == nil && @bill == nil
        @objects = orders
      elsif orders == nil && @bill == nil
        @objects = tickets
      else
        @objects = @bill
      end
      select_store if @bill == nil
      if @bill == nil
        if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
          @store = current_user.store
        else
          if @objects.first.pending_movements != []
            @store = @objects.first.pending_movements.first.product.business_unit.stores.first
          elsif @objects.first.movements != []
            @store = @objects.first.movements.first.product.business_unit.stores.first
          elsif @objects.first.service_offereds != []
            @store = @objects.first.service_offereds.first.service.business_unit.stores.first
          end
        end
      else
        @store = @bill.store
      end
      if (params[:cfdi_type] == 'global' || @cfdi_type == 'global')
        @prospect = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
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
        redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
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
            @rows = @bill.rows
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

          if params[:relation_type] != nil
            relation_type = RelationType.find_by_key(params[:relation_type])
            @relation = relation_type
            @relation_type = relation_type.key
          elsif @relation_type != nil
            relation_type = RelationType.find(@relation_type)&.first
            @relation = relation_type
            @relation_type = relation_type.key
          end
          @relation_type == '01' ? @credit_note = true : @credit_note = false

          unless @objects.class == Bill
            if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
              @relation_type = ''
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
          end
          @cfdi_use_key = cfdi_use.key
          @cfdi_use = cfdi_use.description

          if @bill != nil
            @payment_key  = @bill.payment_form.payment_key # Forma de pago
            @payment_description = @bill.payment_form.description # Forma de pago
            @method_key = PaymentMethod.find_by_method('PUE').method # Método de pago
            @method_description = PaymentMethod.find_by_method('PUE').description # método de pago
            @payment_form = @bill.payment_conditions # Condiciones de pago
            @rows = @bill.rows
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
          if params[:relation_type] != nil
            relation_type = RelationType.find_by_key(params[:relation_type])
            @relation = relation_type
            @relation_type = relation_type.key
          elsif @relation_type != nil
            relation_type = RelationType.find(@relation_type)&.first
            @relation = relation_type
            @relation_type = relation_type.key
          end
          @relation_type == '01' ? @credit_note = true : @credit_note = false

          unless @objects.class == Bill
            if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
              @relation_type = ''
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
          payments << [payment.payment_form.description, payment.total] unless payment.payment_type == 'crédito'
          real_payments << payment
        end
        object.children.each do |children|
          children.payments.each do |pay|
            payments << [pay.payment_form.description, pay.total] unless pay.payment_type == 'crédito'
            real_payments << pay
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
    @total_payment
  end

  def greatest_payment_key
    get_payments
    @greatest_payment = PaymentForm.find_by_description(@payments&.first&.first)
    @greatest_payment
  end

  def get_returns_or_changes_(ticket)
    difference = []
    ticket.children.each do |ticket|
      difference << ticket.total
    end
    difference = difference.inject(&:+)
    difference == nil ? @difference = 0 : @difference = difference
    @difference
  end

  def get_total_with_returns_or_changes_(ticket)
    get_returns_or_changes_(ticket)
    @ticket_total = ticket.total + @difference
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
      @payment_form += ' ' + days.to_s + ' ' + días unless (days == nil || days == [] || days == [''] || days == '')
    end
    @payment_form
  end

  def subtotal
      amounts = []
    @rows.each do |row|
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
      if @bill != nil
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
    @type_of_bill_key
    @type_of_bill_description
    @time.slice(0..18)
    @store_rfc
    @prospect_rfc
    @store_name
    @prospect_name
    @tax_regime_key
    @tax_regime
    @cfdi_use_key
    @cfdi_use
    @payment_key
    @payment_description
    @method_key
    @method_description
    @payment_form
    @bill
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
    # Tal vez tenga que cambiar el else de if tickets == nil para agregar este escenario
  end

  def cfdi_process
    debugger
    if params[:bill] != nil
      @bill = Bill.find(params[:bill])
    end
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    tickets == nil ? @objects = orders : @objects = tickets
    if (tickets == nil && @bill == nil)
      @objects = orders
    elsif (orders == nil && @bill == nil)
      @objects = tickets
    else
      @objects = @bill
    end
    if @bill != nil
      @store = @bill.store
      @bill.bill_type == 'global' ? @cfdi_type == 'global' : @cfdi_type == nil
      @relation_type = params[:relation_type]
      get_series_and_folio
    end

    if @bill == nil
      if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
        @store = current_user.store
      else
        if @objects.first.pending_movements != []
          @store = @objects.first.pending_movements.first.product.business_unit.stores.first
        elsif @objects.first.movements != []
          @store = @objects.first.movements.first.product.business_unit.stores.first
        elsif @objects.first.service_offereds != []
          @store = @objects.first.service_offereds.first.service.business_unit.stores.first
        end
      end
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
      prospect = Prospect.where(legal_or_business_name:'Público en General', direct_phone: 1111111111, prospect_type: 'público en general', contact_first_name: 'ninguno', contact_last_name: 'ninguno', store: @store).first
      @prospect = prospect
      p_billing = prospect.billing_address
      @p_billing = p_billing
      @date = Time.now.strftime('%FT%T')
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
      if @bill != nil
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
          @relation_type = ''
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
      @date = Time.now.strftime('%FT%T')
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
      end
      cfdi_use = cfdi_use.first if cfdi_use.class == Array
      @use = cfdi_use
      @cfdi_use_key = cfdi_use.key
      @cfdi_use = cfdi_use.description

      if @bill != nil
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
          zeroes = quantities_unfiltered.each_index.select{|i| quantities_unfiltered[i] == '0'}
          quantities_filtered = quantities_unfiltered.delete_if.with_index{ |e,i| zeroes.include?(i) }
          products_filtered = products_unfiltered.delete_if.with_index{ |e,i| zeroes.include?(i) }
          quantities_filtered.count.times do
            product = Product.find(products_filtered[n])
            id = product.id
            row = @bill.rows.select{|row| row.product == id}.first
            new_row = Row.new.tap do |r|
              r.unique_code = row.unique_code
              r.quantity = quantities_filtered[n]
              r.description = product.description
              r.unit_value = row.unit_value
              r.sat_unit_key = row.sat_unit_key
              r.sat_unit_description = row.sat_unit_description
              r.sat_key = row.sat_key
              r.total = (row.total / row.quantity * quantities_filtered[n].to_i).round(2)
              r.subtotal = (row.subtotal / row.quantity * quantities_filtered[n].to_i).round(2)
              r.discount = (row.discount / row.quantity * quantities_filtered[n].to_i).round(2)
              r.taxes = (row.taxes / row.quantity * quantities_filtered[n].to_i).round(2)
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

      if params[:relation_type] != nil
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
          @relation_type = ''
          get_series_and_folio
        end
      end
    end
    create_directories
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

  def create_directories
    # Detalla las variables necesarias para los directorios
    @store
    @p_rfc = @prospect_rfc
    @base = Rails.root.join('public', 'uploads')

    # Crea los directorios
    `mkdir -p "#{@base}"/bill_files/#{@store.id}/#{@time}-#{@p_rfc}`
    `mkdir -p #{@base}/bill_files/#{@store.id}/#{@time}-#{@p_rfc}_final`

    # Crea las variables de los directorios a utilizar
    @working_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@time}-#{@p_rfc}")
    @working_dir = Dir.pwd + "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}"
    @final_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@time}-#{@p_rfc}_final")
    @final_dir = Dir.pwd + "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}_final"
    @xml_path = "/public/uploads/bill_files/#{@store.id}/#{@time}-#{@p_rfc}_final"
    @sat_path = Rails.root.join('lib', 'sat')
    @store_path = Rails.root.join('public', 'uploads', 'store', "#{@store.id}")
  end

  #FACTURA GENERAL:
    # SIEMPRE 'I' (TipoDeComprobante) TypeOfBill.find(1).key
    # SIEMPRE 'PUE' (MetodoPago) PaymentMethod.find(1).method
    # SIEMPRE 'P01' (UsoCFDI) CfdiUse.find(23).key
    # SIEMPRE '01010101' (SatKey) SatKey.find(1).sat_key
    # SIEMPRE Número de Ticket en lugar de código de producto (NoIdentificacion) row['ticket']
    # SIEMPRE '1' (Cantidad)
    # SIEMPRE 'ACT' (ClaveUnidad)

  def create_unsigned_xml_file
    s = @store
    b = s.business_unit.billing_address
    p_b = @prospect.billing_address

    e_name = b.business_name
    e_name_clean = e_name.gsub(",", '').gsub(".", '')

    r_name = p_b.business_name
    r_name_clean = r_name.gsub(",", '').gsub(".", '')

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
      hash["SubTotal"] = '%.2f' % @subtotal
      hash["Descuento"] = '%.2f' % @total_discount if (@discount_any && @type_of_bill_key == 'I')
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
      hash["TasaOCuota"] = "0.160000"
      hash["Importe"] = '%.2f' % @total_taxes
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
              @general_bill ? hash["ValorUnitario"] = '%.2f' % row["subtotal"] : hash["ValorUnitario"] = '%.2f' % row["unit_value"]
              hash["Importe"] = '%.2f' % row["subtotal"]
              hash["Descuento"] = '%.2f' % row["discount"] unless row["discount"] == 0
            end
            transfer = Hash.new.tap do |hash|
              hash["Base"] = '%.2f' % (row["subtotal"] - row["discount"])
              hash["Impuesto"] = "002"
              hash["TipoFactor"] = "Tasa"
              hash["TasaOCuota"] = "0.160000"
              hash["Importe"] = '%.2f' % row["taxes"]
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
        xml['cfdi'].Impuestos('TotalImpuestosTrasladados'=> @total_taxes) do
          xml['cfdi'].Traslados do
            xml['cfdi'].Traslado(total_transfer)
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
    `openssl dgst -sha256 -out #{bin} -sign #{new_pem} #{original}`

    # Crea y lee un archivo en blanco para guardar el sello digital
    stmp = File.open(File.join(@working_dir, 'stamp.txt'), 'w'){ |file| file.write('') }
    stamp = @working_path.join('stamp.txt')

    # Ejecuta el proceso de sello digital y lo guarda en el archivo
    `openssl enc -in #{bin} -a -A -out #{stamp}`

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

    soap_response = File.open(File.join(@working_dir, 'response.xml'), 'w'){ |file| file.write(response) }

    soap_request = File.open(File.join(@working_dir, 'request.xml'), 'w'){ |file| file.write(request) }

    @receipt_file = File.open(File.join(@final_dir, 'acuse.xml'), 'r')

    @bill.update(cancel_receipt: @receipt_file, status: 'cancelada')

    redirect_to root_path, notice: "Se ha cancelado exitosamente la factura con Folio #{@bill.folio}."
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

    # Resume el método para llamar las distintas partes del hash del webservice
    hash = response_hash[:envelope][:body][:stamp_response][:stamp_result]

    #Separa los métodos según las partes que se necesitan
    xml_response = hash[:xml]
    @uuid = hash[:uuid]
    @date = hash[:fecha]
    @cod_status = hash[:cod_estatus]
    @sat_seal = hash[:sat_seal]
    @sat_certificate = hash[:no_certificado_sat]
    @incidents_hash = hash[:incidencias]

    if @cod_status == 'Comprobante timbrado satisfactoriamente'
      incidents = File.open(File.join(@working_dir, 'incidencias.txt'), 'w'){ |file| file.write(@incidents_hash) }

      #Separa la parte del timbre fiscal digital para generar cadena original (y quita la parte que genera error)
      doc = Nokogiri::XML(xml_response)

      extract = doc.xpath('//cfdi:Complemento').children.to_xml.gsub('xsi:', '')

      #Obtiene el atributo SelloCFD
      @cfd_stamp = doc.xpath('//cfdi:Complemento').children.attr('SelloCFD').value

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
        bill.bill_folio_type = "Aplicaición de Anticipo"
      elsif @series.include?("FA")
        bill.bill_folio_type = "Anticipo"
      else
        bill.bill_folio_type = "Factura"
      end
    end
    if bill.save
      if @bill != nil
        @bill.children << bill
      end
      if @bill == nil
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
        @rows.each do |row|
          row.update(bill: bill)
        end
      end
      # El update de folio solo sirve para las facturas normales por el momento
      bill.update(xml: @stamped_xml, pdf: @pdf_file)
      if @bill == nil
        @store.update(bill_last_folio: @folio)
      else
        if @relation_type == '01'
          @store.update(credit_note_last_folio: @folio)
        elsif @relation_type == '02'
          @store.update(debit_note_last_folio: @folio)
        elsif @relation_type == '03'
          @store.update(return_last_folio: @folio)
        elsif @relation_type == '07'
          @store.update(advance_e_last_folio: @folio)
        end
      end

      if @objects.is_a?(Array)
        @objects.each do |object|
          object.update(bill: bill)
          object.payments.each do |payment|
            payment.update(bill: bill) if bill.bill_folio_type == 'Factura'
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
      else
        @objects.payments.each do |payment|
          payment.update(bill: bill)
        end
        @objects.store_movements.each do |mov|
          mov.update(bill: bill)
        end
        @objects.service_offereds.each do |serv|
          serv.update(bill: bill)
        end
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
        new_hash["total"] += o.total.round(2) unless o.total == nil
        new_hash["unit_value"] += o.subtotal.round(2) unless o.subtotal == nil
        new_hash["subtotal"] += o.subtotal.round(2) unless o.subtotal == nil
        new_hash["taxes"] += o.taxes.round(2) unless o.taxes == nil
        new_hash["discount"] += o.discount_applied.round(2) unless o.discount_applied == nil
        o.children.each do |children|
          new_hash["total"] += children.total.round(2) unless children.total == nil
          new_hash["unit_value"] += children.subtotal.round(2) unless children.subtotal == nil
          new_hash["subtotal"] += children.subtotal.round(2) unless children.subtotal == nil
          new_hash["taxes"] += children.taxes.round(2) unless children.taxes == nil
          new_hash["discount"] += children.discount_applied.round(2) unless children.discount_applied == nil
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
              @rows[i]["quantity"] += sm.quantity
              @rows[i]["total"] += sm.total.round(2)
              @rows[i]["subtotal"] += sm.subtotal.round(2)
              @rows[i]["taxes"] += sm.taxes.round(2)
              @rows[i]["discount"] += sm.discount_applied.round(2)
            end
          end
          children.service_offereds.each do |so|
            serv = so.product.unique_code
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
              @rows[i]["quantity"] += so.quantity
              @rows[i]["total"] += so.total.round(2)
              @rows[i]["subtotal"] += so.subtotal.round(2)
              @rows[i]["taxes"] += so.taxes.round(2)
              @rows[i]["discount"] += so.discount_applied.round(2)
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
        o.movements.each do |mov|
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
          new_hash["quantity"] = mov.quantity
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
        o.pending_movements.each do |mov|
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
          new_hash["quantity"] = mov.quantity
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
    qr = site + '&id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello
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
    if @general_bill
      pdf = render_to_string pdf: "factura", template: 'bills/global_doc', page_size: 'Letter', layout: 'bill.html', encoding: "UTF-8"
    else
      pdf = render_to_string pdf: "factura", template: 'bills/doc', page_size: 'Letter', layout: 'bill.html', encoding: "UTF-8"
    end
    save_path = Rails.root.join('public', 'uploads', 'bill_files', "#{@store.id}", "#{@time}-#{@p_rfc}_final", 'factura.pdf')
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
      :taxes_witheld
      )
    end
end
