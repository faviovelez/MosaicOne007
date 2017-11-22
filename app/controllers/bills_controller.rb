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
    @orders = Order.where(status: 'en espera').where(bill: nil)
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

  def preview
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    tickets == nil ? @objects = orders : @objects = tickets
    prospect = Prospect.find(params[:prospect]).first
    if prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    else
      if params[:cfdi_type] == 'global'
        redirect_to bills_global_preview_path()
        @general_bill = true
      else
        @general_bill = false
        store = current_user.store
        s_billing = store.business_unit.billing_address
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL prospect = Prospect.find_by_legal_or_business_name('Público en General')
        p_billing = prospect.billing_address
        @series = store.series
        @folio = store.bill_last_folio.next
        @date = Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        type_of_bill = TypeOfBill.find(params[:type_of_bill])
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name.split.map(&:capitalize)*' '
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL NO DEBE SALIR
        @prospect_name = p_billing.business_name.split.map(&:capitalize)*' '
        regime = current_user.store.business_unit.billing_address.tax_regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL CfdiUse.find_by_key('P01')
        cfdi_use = CfdiUse.find(params[:cfdi_use]).first
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description
        greatest_payment_key
        @payment_key = @greatest_payment.payment_id
        @payment_description = @payments.first.first
        payment_method_(@objects, @total_payment, @list_of_real_payments)
        @method_description = @method.description
        @method_key = @method.method
        @payment_form
        rows(@general_bill, @objects)
        @rows
        subtotal
        total_taxes
        total
        total_discount
      end
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
    @greatest_payment = PaymentForm.find_by_description(@payments.first.first)
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
    if total_all_objects <= total_payments
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
      total = row["total"]
      amounts << total
    end
    total = amounts.inject(&:+)
    @total = total.round(2)
    @total
  end

  def total_discount
    amounts = []
    @rows.each do |row|
      total = row["discount"]
      amounts << total
    end
    @total_discount = amounts.inject(&:+)
    @total_discount
  end

  def global_preview
    @date = Time.now.strftime('%FT%T')
    @tickets_selected = []
    tickets = params[:tickets].split('/')
    tickets.each do |ticket|
      @tickets_selected << Ticket.find(ticket)
    end
    @prospect = Prospect.find_by_legal_or_business_name('Público en General')
    cfdi_use = CfdiUse.find(params[:cfdi_use])
    @cfdi_use = cfdi_use.description
    @cfdi_use_key = cfdi_use.key
    type_of_bill = TypeOfBill.find(params[:type_of_bill])
    @type_of_bill_key = type_of_bill.key
    @type_of_bill =  ' ' + '-' + ' ' + type_of_bill.description
    if @prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    end
  end

  def cfdi_process
    params[:tickets] == nil ? tickets = nil : tickets = Ticket.find(params[:tickets])
    params[:orders] == nil ? orders = nil : orders = Order.find(params[:orders])
    tickets == nil ? @objects = orders : @objects = tickets
    prospect = Prospect.find(params[:prospect]).first
    @prospect = prospect
    if prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    else
      if params[:cfdi_type] == 'global'
        redirect_to bills_global_preview_path()
        @general_bill = true
      else
        @general_bill = false
        store = current_user.store
        s_billing = store.business_unit.billing_address
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL prospect = Prospect.find_by_legal_or_business_name('Público en General')
        p_billing = prospect.billing_address
        @series = store.series
        @folio = store.bill_last_folio.next
        @date = Time.now.strftime('%FT%T')
        @zipcode = store.zip_code
        type_of_bill = TypeOfBill.find(params[:type_of_bill])
        @type_of_bill_key = type_of_bill.key
        @type_of_bill = type_of_bill.description
        @store_rfc = s_billing.rfc.upcase
        @prospect_rfc = p_billing.rfc.upcase
        @store_name = s_billing.business_name.split.map(&:capitalize)*' '
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL NO DEBE SALIR
        @prospect_name = p_billing.business_name.split.map(&:capitalize)*' '
        regime = current_user.store.business_unit.billing_address.tax_regime
        @tax_regime_key = s_billing.tax_regime.tax_id
        @tax_regime = s_billing.tax_regime.description
        # CAMBIAR ESTA PARTE CUANDO SEA GLOBAL CfdiUse.find_by_key('P01')
        cfdi_use = CfdiUse.find(params[:cfdi_use]).first
        @cfdi_use_key = cfdi_use.key
        @cfdi_use = cfdi_use.description
        greatest_payment_key
        @payment_key = @greatest_payment.payment_id
        @payment_description = @payments.first.first
        payment_method_(@objects, @total_payment, @list_of_real_payments)
        @method_description = @method.description
        @method_key = @method.method
        @payment_form
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
        if (@objects.first.is_a?(Ticket) || @objects.first.is_a?(Order))
          @credit_note = false
          @relation_type = ''
        else # Esto está incompleto, agregar por si puede ser devolución o pago
          @credit_note = true

          # Agregar validación de relation type para cuando es nota de crédito, devolución o pago
        end
      end
    end
    create_directories
    create_unsigned_xml_file
    generate_digital_stamp
    get_stamp_from_pac
    save_to_db
  end

  def create_directories
    # Detalla las variables necesarias para los directorios
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      @store = current_user.store
    else
      @store = @objects.first.movements.first.product.business_unit.stores.first
    end
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
      if @relation_type == '' || @relation_type == '04'
        hash["Serie"] = s.series
        hash["Folio"] = s.bill_last_folio.next
      elsif @relation_type == '01'
        hash["Serie"] = 'NC'+ s.store_code
        hash["Folio"] = s.credit_note_last_folio.next
      elsif @relation_type == '02'
        hash["Serie"] = 'ND'+ s.store_code
        hash["Folio"] = s.debit_note_last_folio.next
      elsif @relation_type == '03'
        hash["Serie"] = 'DE'+ s.store_code
        hash["Folio"] = s.return_last_folio.next
      elsif (@relation_type == '07' && @type_of_bill_key == 'I')
        hash["Serie"] = 'AI'+ s.store_code
        hash["Folio"] = s.advance_e_last_folio.next
      elsif (@relation_type == '07' && @type_of_bill_key == 'E')
        hash["Serie"] = 'AE'+ s.store_code
        hash["Folio"] = s.advance_i_last_folio.next
      end

      hash["Fecha"] = @time
      hash["Sello"] = ''
      hash["FormaPago"] = @greatest_payment.payment_id
      hash["NoCertificado"] = s.certificate_number
      hash["Certificado"] = ''
      hash["CondicionesDePago"] = @payment_form unless (@general_bill || @payment_form == '' || @payment_form == nil)
      hash["SubTotal"] = subtotal
      hash["Descuento"] = total_discount if (@discount_any && @type_of_bill_key == 'I')
      hash["Moneda"] = 'MXN'
      hash["TipoCambio"] = '1'
      hash["Total"] = total
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
      hash["Importe"] = total_taxes.round(2)
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
              ### CREAR MÉTODO PARA SUMAR EL TOTAL DE ARTÍCULOS POR TICKET ###
              @general_bill ? hash["ValorUnitario"] = row["subtotal"].round(2) : hash["ValorUnitario"] = row["unit_value"].round(2)
              hash["Importe"] = row["subtotal"].round(2)
              ### CREAR MÉTODO PARA SUMAR EL TOTAL DESCUENTOS POR TICKET ###
              hash["Descuento"] = row["discount"].round(2) unless row["discount"] == 0
            end
            transfer = Hash.new.tap do |hash|
              hash["Base"] = row["subtotal"].round(2)
              hash["Impuesto"] = "002"
              hash["TipoFactor"] = "Tasa"
              hash["TasaOCuota"] = "0.160000"
              hash["Importe"] = row["taxes"].round(2)
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
        xml['cfdi'].Impuestos('TotalImpuestosTrasladados'=> total_taxes.round(2)) do
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
    debugger
  end

  def encode_b64_cer
    cer_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.pem")
    cer_des3_b64 = Base64.encode64(File.read(cer_pem))
  end

  def encode_b64_key_enc
    file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key")
    key_des3_b64 = Base64.encode64(File.read(file))
    ##TAL VEZ GUARDE EN UNA CONSTANTE EL PASSWORD DE FINKOK##
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

      ###### CREO QUE ESTE CÓDIGO ESTÁ MAL, NO SON STORE MOVEMENTS NI SERVICE OFFEREDS ######

      objects.each do |ticket|
        ticket.store_movements.each do |sale|
          @rows << sale
        end
        ticket.service_offereds.each do |serv|
          @rows << serv
        end
      end
    else (general_bill == false && objects.first.is_a?(Order))
      objects.each do |ticket|
        ticket.store_movements.each do |sale|
          @rows << sale
        end
        ticket.service_offereds.each do |serv|
          @rows << serv
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
    id = 'F7C0E3BC-B09D-482F-881E-3F6B063DED31'
    emisor = current_user.store.business_unit.billing_address.rfc
    receptor = Prospect.find(params[:prospect]).billing_address.rfc
    total = @total.round(2).to_s
    sello = 'A1345678'
    @qr = RQRCode::QRCode.new( (site + '&id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello),  :size => 13, :level => :h )
  end

  def global_qrcode
    site = 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx'
    id = 'F7C0E3BC-B09D-482F-881E-3F6B063DED31'
    emisor = current_user.store.business_unit.billing_address.rfc
    receptor = Prospect.find_by_legal_or_business_name('Público en General').billing_address.rfc
    total = @total.round(2).to_s
    sello = 'A1345678'
    @qr = RQRCode::QRCode.new( (site + '&id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello),  :size => 13, :level => :h )
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

  def generate_stamp_original_chain
    xml = Nokogiri::XML(File.read(Rails.root.join('lib', 'sat', 'test.xml')))
    xslt = Nokogiri::XSLT(File.read(Rails.root.join('lib', 'sat', 'cadenaoriginal_TFD_1_1.xslt')))
    @stamp_original_chain = xslt.apply_to(xml)
  end

# PROBABLEMENTE NO NECESITARÉ ESTOS MÉTODOS
  def generate_original_chain
    xml = Nokogiri::XML(File.read(Rails.root.join('lib', 'sat', 'test.xml')))
    xslt = Nokogiri::XSLT(File.read(Rails.root.join('lib', 'sat', 'cadenaoriginal_3_3.xslt')))
    @original_chain = xslt.apply_to(xml)
  end

  def save_cer_as_cer_pem
    cert = File.open(Rails.root.join('lib', 'cer', 'test', 'ACO560518KW7-20001000000300005692.cer'), )
    File.open("ACO560518KW7-20001000000300005692.cer", "wb") { |f| f.write cert.to_pem }
  end

  def save_cer_pem_as_der
  end

  def save_key_as_pem
    ACO560518KW7-20001000000300005692.key
  end

  def encrypt_in_des3
  end

  def unencrypt_from_des3
  end
# PROBABLEMENTE NO NECESITARÉ ESTOS MÉTODOS

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
      :payment_condition_id,
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
