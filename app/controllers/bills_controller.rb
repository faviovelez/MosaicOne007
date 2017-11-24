class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :bill, :bill_doc, :update, :destroy]

  require 'rqrcode'
  require 'savon'
  require 'base64'

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
  end

  def select_tickets(user_role = current_user.role.name)
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
    @tickets == nil ? objects = @orders : objects = @tickets
    if objects.first.is_a?(Ticket)
      get_cfdi_use_from_tickets(@tickets)
    else
      @cfdi_use = CfdiUse.first
    end
    get_prospect_from_objects(objects)
    @type_of_bill = TypeOfBill.first
    @tickets = params[:tickets] unless params[:tickets] == nil
    @orders = params[:orders] unless params[:orders] == nil
  end

  def global_preview
  end

  def preview
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    tickets == nil ? @objects = orders : @objects = tickets
    prospect = Prospect.find(params[:prospect]).first
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @store = current_user.store
    else
      if @objects.first.movements == []
        @store = @objects.first.pending_movements.first.product.business_unit.stores.first
      else
        @store = @objects.first.movements.first.product.business_unit.stores.first
      end
    end
    @folio = ''
    @series = ''
    if prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    else
      if params[:cfdi_type] == 'global'
        @general_bill = true
        store = @store
        s_billing = store.business_unit.billing_address
        prospect = Prospect.find_by_legal_or_business_name('Público en General')
        @prospect = prospect
        p_billing = prospect.billing_address
        @date = Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        type_of_bill = TypeOfBill.find(params[:type_of_bill])
        @bill_type = type_of_bill
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name.split.map(&:capitalize)*' '
        @prospect_name = ''
        regime = s_billing.tax_regime
        @regime = regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description
        cfdi_use = CfdiUse.find_by_key('P01')
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description
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
        subtotal
        total_taxes
        total
        total_discount
        if @total_discount.to_f > 0
          @discount_any = true
        else
          @discount_any = false
        end
        @relation_type = ''
        unless params[:relation_type] == nil
          relation_type = RelationType.find(params[:relation_type])&.first
          @relation = relation_type
          @relation_type = relation_type.key
        end
        @credit_note = false
        if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
          @relation_type = ''
          get_series_and_folio
        end
        @series
        @folio
        render 'global_preview'
      else
        prospect = Prospect.find(params[:prospect]).first
        @prospect = prospect
        @general_bill = false
        store = @store
        s_billing = store.business_unit.billing_address
        p_billing = prospect.billing_address
        @date = Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        type_of_bill = TypeOfBill.find(params[:type_of_bill])
        @bill_type = type_of_bill
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name.split.map(&:capitalize)*' '
        @prospect_name = p_billing.business_name.split.map(&:capitalize)*' '
        regime = s_billing.tax_regime
        @regime = regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL CfdiUse.find_by_key('P01')
        cfdi_use = CfdiUse.find(params[:cfdi_use]).first
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description
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
        subtotal
        total_taxes
        total
        total_discount
        if @total_discount.to_f > 0
          @discount_any = true
        else
          @discount_any = false
        end
        @relation_type = ''
        unless params[:relation_type] == nil
          relation_type = RelationType.find(params[:relation_type])&.first
          @relation = relation_type
          @relation_type = relation_type.key
        end
        @credit_note = false
        if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
          @relation_type = ''
          get_series_and_folio
        end
      end
    end
  end

  def get_series_and_folio
    if (@relation_type == '' || @relation_type == '04')
      @series = @store.series
      @folio = @store.bill_last_folio.to_i.next
    elsif @relation_type == '01'
      @series = 'NC'+ @store.store_code
      @folio = @store.credit_note_last_folio.to_i.next
      @credit_note = true
    elsif @relation_type == '02'
      @series = 'ND'+ @store.store_code
      @folio = @store.debit_note_last_folio.to_i.next
    elsif @relation_type == '03'
      @series = 'DE'+ @store.store_code
      @folio = @store.return_last_folio.to_i.next
    elsif (@relation_type == '07' && @type_of_bill_key == 'I')
      @series = 'AI'+ @store.store_code
      @folio = @store.advance_e_last_folio.to_i.next
    elsif (@relation_type == '07' && @type_of_bill_key == 'E')
      @series = 'AE'+ @store.store_code
      @folio = @store.advance_i_last_folio.to_i.next
    end
  end

  def get_payments
    objects = @objects
    payments = []
    real_payments = []
    if objects.first.is_a?(Ticket)
      objects.each do |object|
        object.payments.each do |payment|
          payments << [payment.payment_form.description, payment.total]
          real_payments << payment
        end
        object.children.each do |children|
          children.payments.each do |pay|
            payments << [pay.payment_form.description, pay.total]
            real_payments << pay
          end
        end
      end
    else
      objects.each do |object|
        object.payments.each do |payment|
          payments << [payment.payment_form.description, payment.total]
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
      amounts << row["subtotal"]
    end
    subtotal = amounts.inject(&:+)
    @subtotal = subtotal.round(2)
    @subtotal
  end

  def total_taxes
    amounts = []
    @rows.each do |row|
      amounts << row["taxes"]
    end
    total_taxes = amounts.inject(&:+)
    @total_taxes = total_taxes.round(2)
    @total_taxes
  end

  def total
    amounts = []
    @rows.each do |row|
      amounts << row["total"]
    end
    total = amounts.inject(&:+)
    @total = total.round(2)
    @total
  end

  def total_discount
    amounts = []
    @rows.each do |row|
      amounts << row["discount"]
    end
    @total_discount = amounts.inject(&:+)
    @total_discount
  end

  def cfdi_process
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    tickets == nil ? @objects = orders : @objects = tickets
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @store = current_user.store
    else
      if @objects.first.movements == []
        @store = @objects.first.pending_movements.first.product.business_unit.stores.first
      else
        @store = @objects.first.movements.first.product.business_unit.stores.first
      end
    end
    if params[:cfdi_type] == 'global'
      @general_bill = true
      store = @store
      s_billing = store.business_unit.billing_address
      @s_billing = s_billing
      # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL prospect = Prospect.find_by_legal_or_business_name('Público en General')
      prospect = Prospect.find_by_legal_or_business_name('Público en General')
      @prospect = prospect
      p_billing = prospect.billing_address
      @p_billing = p_billing
      @date = Time.now.strftime('%FT%T')
      @zipcode = store.zip_code
      type_of_bill = TypeOfBill.find(params[:type_of_bill])
      @bill_type = type_of_bill
      @type_of_bill_key = type_of_bill.key
      @type_of_bill = type_of_bill.description
      @store_rfc = s_billing.rfc.upcase
      @prospect_rfc = p_billing.rfc.upcase
      @store_name = s_billing.business_name.split.map(&:capitalize)*' '
      @prospect_name = ''
      regime = s_billing.tax_regime
      @regime = regime
      @tax_regime_key = s_billing.tax_regime.tax_id
      @tax_regime = s_billing.tax_regime.description
      cfdi_use = CfdiUse.find_by_key('P01')
      @use = cfdi_use
      @cfdi_use_key = cfdi_use.key
      @cfdi_use = cfdi_use.description
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
      subtotal
      total_taxes
      total
      total_discount
      if @total_discount.to_f > 0
        @discount_any = true
      else
        @discount_any = false
      end
      @relation_type = ''
      unless params[:relation_type] == nil
        relation_type = RelationType.find(params[:relation_type])&.first
        @relation = relation_type
        @relation_type = relation_type.key
      end
      @credit_note = false
      if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
        @relation_type = ''
        get_series_and_folio
      end
    else
      @general_bill = false
      store = @store
      s_billing = store.business_unit.billing_address
      @s_billing = s_billing
      prospect = Prospect.find(params[:prospect]).first
      @prospect = prospect
      # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL prospect = Prospect.find_by_legal_or_business_name('Público en General')
      p_billing = prospect.billing_address
      @p_billing = p_billing
      @date = Time.now.strftime('%FT%T')
      @zipcode = store.zip_code
      type_of_bill = TypeOfBill.find(params[:type_of_bill])
      @bill_type = type_of_bill
      @type_of_bill_key = type_of_bill.key
      @type_of_bill = type_of_bill.description
      @store_rfc = s_billing.rfc.upcase
      @prospect_rfc = p_billing.rfc.upcase
      @store_name = s_billing.business_name.split.map(&:capitalize)*' '
      # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL NO DEBE SALIR
      @prospect_name = p_billing.business_name.split.map(&:capitalize)*' '
      regime = s_billing.tax_regime
      @regime = regime
      @tax_regime_key = s_billing.tax_regime.tax_id
      @tax_regime = s_billing.tax_regime.description
      # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL CfdiUse.find_by_key('P01')
      cfdi_use = CfdiUse.find(params[:cfdi_use]).first
      @use = cfdi_use
      @cfdi_use_key = cfdi_use.key
      @cfdi_use = cfdi_use.description
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
        @payment_key = @greatest_payment._payment.payment_key
        @payment_description = @payments.first.first
        payment_method_(@objects, @total_payment, @list_of_real_payments)
        @method_description = @method.description
        @method_key = @method.method
        @payment_form
      end
      rows(@general_bill, @objects)
      @rows
      subtotal
      total_taxes
      total
      total_discount
      if @total_discount.to_f > 0
        @discount_any = true
      else
        @discount_any = false
      end
      @relation_type = ''
      unless params[:relation_type] == nil
        relation_type = RelationType.find(params[:relation_type])&.first
        @relation = relation_type
        @relation_type = relation_type.key
      end
      @credit_note = false
      if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
        @relation_type = ''
        get_series_and_folio
      end
    end
    create_directories
    create_unsigned_xml_file
    generate_digital_stamp
    get_stamp_from_pac
    qrcode_print
    save_to_db
    if @incidents_hash == nil
      redirect_to root_path, notice: 'Su factura se ha guardado con éxito.'
    else
      redirect_to root_path, notice: 'No se pudo generar la factura, por favor intente de nuevo.'
    end
  end

  def create_directories
    # Detalla las variables necesarias para los directorios
    @store
    @p_rfc = @prospect_rfc
    @time = Time.now.strftime('%FT%T')
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
            xml['cfdi'].CfdiRelacionado('UUID' => '') #revisar quévoy a poner aquí
          end
        end
        xml['cfdi'].Emisor(issuer)
        xml['cfdi'].Receptor(receiver)
        xml['cfdi'].Conceptos do
          @rows.each do |row|
            ## Aquí debo agregar descuento en concepto
            concept = Hash.new.tap do |hash|
              @general_bill ? hash["ClaveProdServ"] = "01010101" : hash["ClaveProdServ"] = row["sat_key"]
              @general_bill ? hash["NoIdentificacion"] = row["ticket"] : hash["NoIdentificacion"] = row["unique_code"]
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

  #### ESTE MÉTODO ES PARA BILL ### ##CAMBIAR POR MÉTODO PARA SOLO TIMBRE FISCAL SIN SELLO#
  def get_stamp_from_pac
    #Crea un cliente SOAP con Savon
    client = Savon.client(wsdl: "https://demo-facturacion.finkok.com/servicios/soap/stamp.wsdl")

    #Carga el XML para ser timbrado
    file = File.read(@working_path.join('unsigned.xml')) ## CAMBIAR A UNSTAMPED CUANDO SEAN EXITOSAS LAS PRUEBAS

    #Cifra el XML en Base64
    xml_file = Base64.encode64(file)

    #Correo y contraseña de acceso al panel de FINKOK
    username = ENV['username_pac']
    password = ENV['password_pac']
    #Envia la peticion al webservice de timbrado
    ops = client.operation(:sign_stamp) ##CAMBIAR A STAMP CUANDO SEAN EXITOSAS LAS PRUEBAS
    request = ops.build(message: { xml: xml_file, username: username , password: password })

    #Obtiene el SOAP Request y lo guarda en un archivo
    response = client.call(:sign_stamp, message: { xml: xml_file, username: username , password: password })
    response_hash = response.hash

    # Resume el método para llamar las distintas partes del hash del webservice
    hash = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result]

    #Separa los métodos según las partes que se necesitan
    xml_response = hash[:xml]
    @uuid = hash[:uuid]
    @date = hash[:fecha]
    @cod_status = hash[:cod_estatus]
    @sat_seal = hash[:sat_seal]
    @sat_certificate = hash[:no_certificado_sat]
    @incidents_hash = hash[:incidencias]
    debugger
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

    xml_url = @xml_path + 'stamped.xml' ###### CAMBIAR ESTE MÉTODO POR UN NOMBRE DISTITNO DE FACTURA

    #Guarda el extracto del timbre fiscal digital en un XML
    extract_xml = File.open(File.join(@working_dir, 'tfd.xml'), 'w'){ |file| file.write(extract) }

    #Transforma el XML del timbre fiscal digital en una cadena original usando el xslt del SAT
    stamp_xml = Nokogiri::XML(File.read(@working_path.join('tfd.xml')))
    stamp_xslt = Nokogiri::XSLT(File.read(@sat_path.join('cadenaoriginal_TFD_1_1.xslt')))
    @stamp_original_chain = stamp_xslt.apply_to(stamp_xml)
  end

  def save_to_db
    bill = Bill.new.tap do |bill|
      bill.status = 'timbrada'
      # bill.pdf =
      # bill.xml =
      bill.issuing_company = @s_billing
      bill.receiving_company = @p_billing
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
      # bill.automatic_discount_applied =
      bill.manual_discount_applied = @total_discount
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
      # bill.parent = ''
      # bill.children = (este es cuando sean NC o ND o DEV)
    end
    bill.save
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
        end
        o.children.each do |children|
          children.store_movements.each do |sm|
            product = sm.product.unique_code
            ticket = sm.ticket.parent.id
            i = ''
            @rows.each_with_index do |key, index|
              i = index if (key["unique_code"] == product && key["ticket"] == ticket)
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
              i = index if (key["unique_code"] == serv && key["ticket"] == ticket)
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
    object.each do |object|
      object_prospect << object.prospect unless object.prospect == nil
    end
    object_prospect.uniq.length == 1 ? @prospect = object_prospect.first : @prospect = nil
    @prospect
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
