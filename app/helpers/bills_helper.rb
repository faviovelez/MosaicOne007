module BillsHelper

  UNIDADES = [
    '',
    'un ',
    'dos ',
    'tres ',
    'cuatro ',
    'cinco ',
    'seis ',
    'siete ',
    'ocho ',
    'nueve ',
    'uno'
  ]

  DECENAS = [
    '',
    'un ',
    'dos ',
    'tres ',
    'cuatro ',
    'cinco ',
    'seis ',
    'siete ',
    'ocho ',
    'nueve ',
    'diez ',
    'once ',
    'doce ',
    'trece ',
    'catorce ',
    'quince ',
    'dieciséis ',
    'diecisiete ',
    'dieciocho ',
    'diecinueve ',
    'veinte ',
    'veinti',
    'treinta ',
    'cuarenta ',
    'cincuenta ',
    'sesenta ',
    'setenta ',
    'ochenta ',
    'noventa '
  ]

  DECENAS_2 = [
    '',
    'diez',
    'once',
    'doce',
    'trece',
    'catorce',
    'quince',
    'dieciséis',
    'diecisiete',
    'dieciocho',
    'diecinueve',
    'veinte',
    'veinti',
    'treinta',
    'cuarenta',
    'cincuenta',
    'sesenta',
    'setenta',
    'ochenta',
    'noventa'
  ]

  CENTENAS = [
    '',
    'ciento ',
    'doscientos ',
    'trescientos ',
    'cuatrocientos ',
    'quinientos ',
    'seiscientos ',
    'setecientos ',
    'ochocientos ',
    'novecientos ',
    'cien'
  ]

  AGRUPADORES = [
    '',
    'mil ',
    'millones, ',
    'mil millones, ',
    'millón '
  ]

  def decimals(number)
    decimals = ((number % 1).round(2) * 100 ).to_i.to_s
    decimals += '/100 M.N.'
    @decimals = decimals
  end

  def variables_to_number(number)
    @num_s = number.to_s
    @num_length = @num_s.index('.')
    @quantity_in_letters = ''
    decimals(number)
    @num_s = number.to_s
    @num_cent = @num_length / 3
    @num_dec = @num_length / 3
    @order = @num_length % 3
    @num_dec += 1 unless (@num_length % 3 < 2)
    @q_dec = @num_dec
    @q_cent = @num_cent
    if @num_length < 4
      @q_group = 0
    elsif @num_length >= 4 && @num_length < 7
      @q_group = 1
    elsif @num_length >= 7  && @num_length < 10
      @q_group = 2
    elsif @num_length >= 10  && @num_length < 13
      @q_group = 3
    end
    @num_length % 3 == 1 ? @num_unit = 1 : @num_unit = 0
  end

  def centenas
    number = @num_length - (@q_cent * 3)
    position = @num_s[number].to_i
    next_two = @num_s.slice((number + 1)..(number + 2)).to_i
    if (position == 1 && next_two == 0)
      @quantity_in_letters << CENTENAS[10]
    else
      @quantity_in_letters << CENTENAS[position]
    end
    @q_cent -= 1
  end

  def decenas
    result = 2 + (3 * (@q_dec - 1))
    first = @num_length - result
    second = first + 1
    slice_in_dec = @num_s.slice(first..second).to_i
    if (slice_in_dec < 21)
      @quantity_in_letters << DECENAS[slice_in_dec]
    elsif slice_in_dec == 21
      string = 'veintiún '
      @quantity_in_letters << string
    elsif (slice_in_dec > 21 && slice_in_dec < 30)
      string = DECENAS[21] + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 30 && slice_in_dec < 40)
      string = DECENAS[22] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 40 && slice_in_dec < 50)
      string = DECENAS[23] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 50 && slice_in_dec < 60)
      string = DECENAS[24] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 60 && slice_in_dec < 70)
      string = DECENAS[25] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 70 && slice_in_dec < 80)
      string = DECENAS[26] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 80 && slice_in_dec < 90)
      string = DECENAS[27] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 90 && slice_in_dec < 100)
      string = DECENAS[28] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    end
    @q_dec -= 1
  end

  def unidades
    @unit_value = @num_s[0].to_i
    if @num_unit > 0
      @quantity_in_letters << UNIDADES[@unit_value]
    end
    @num_unit -= 1
  end

  def agrupadores
    if (@q_group > 0 && @q_group < 5)
      agr_string = AGRUPADORES[@q_group]
      if agr_string == 'millones, ' && @unit_value == 1
        agr_string = 'millón, '
      end
      @quantity_in_letters << agr_string
    end
    @q_group -= 1
  end

  def number_to_letters(number)
    variables_to_number(number)
    while @q_dec > 0
      if @order == 0
        centenas
        decenas
        agrupadores
      elsif @order == 1
        if @num_unit > 0
          unidades
          agrupadores
        end
        centenas
        decenas
        agrupadores
      else @order == 2
        decenas
        agrupadores
        centenas
      end
    end
    if (@num_length == 1 && @unit_value)
      @quantity_in_letters << 'peso '
    else
      @quantity_in_letters << 'pesos '
    end
    @quantity_in_letters.capitalize
  end

  def address(user = current_user)
    @address = user.store.delivery_address.street + ' ' + user.store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + user.store.delivery_address.interior_number + ' ' unless user.store.delivery_address.interior_number.blank?
    @address += 'Col. ' + user.store.delivery_address.neighborhood + '.' + ' ' + user.store.delivery_address.city + ',' + ' ' + user.store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
  end

  def select_tickets
    if params[:tickets] != nil
      tickets = []
      @tickets.each do |ticket|
        tickets << ticket
      end
      @tickets = tickets
      @tickets
    end
  end

  def select_orders
    if params[:orders] != nil
      orders = []
      @orders.each do |order|
        orders << order
      end
      @orders = orders
      @orders
    end
  end

  def select_series
    @stores.bill_last_folio.to_i.next
  end

  def select_prospect(role = current_user.role.name)
    store = current_user.store
    @prospects = []
    if (role == 'store' || role == 'store-admin')
      prospects = store.prospects
      prospects.each do |prospect|
        @prospects << [prospect.legal_or_business_name, prospect.id]
      end
    else
      b_us = BusinessUnit.find_by_name(['Comercializadora de Cartón y Diseño', 'Diseños de Cartón'])
      if b_us.is_a?(BusinessUnit)
        b_us.prospects.each do |prospect|
          @prospects << [prospect.legal_or_business_name, prospect.id]
        end
      else
        b_us.each do |bu|
          bu.prospects.each do |prospect|
            @prospects << [prospect.legal_or_business_name, prospect.id]
          end
        end
      end
    end
    @prospects
  end

  def check_uncheck_checkbox
    @value = (@prospect != nil)
  end

  def select_cfdi_use
    @uses = []
    CfdiUse.all.each do |use|
      name = use.key + ' ' + '-' + ' ' + use.description
      @uses << [name, use.id]
    end
    @uses
  end

  def select_cfdi_type
    @types = []
    TypeOfBill.all.each do |bill_type|
      string = bill_type.key + ' ' + '-' + ' ' + bill_type.description
      @types << [string, bill_type.id]
    end
    @types
  end

  def store_rfc
    @store_rfc = current_user.store.business_unit.billing_address.rfc.upcase
  end

  def ticket_user(ticket)
    @name = ''
    user = ticket.user
    string = user.first_name.split.map(&:capitalize)*' '
    @name << string + ' '
    user.middle_name == nil ? string = '' : user.middle_name.split.map(&:capitalize)*' '
    @name << string
    string = user.last_name.split.map(&:capitalize)*' '
    @name << string
    @name
  end

  def get_returns_or_changes(ticket)
    difference = []
    ticket.children.each do |ticket|
      difference << ticket.total
    end
    difference = difference.inject(&:+)
    difference == nil ? @difference = 0 : @difference = difference
    @difference
  end

  def get_total_with_returns_or_changes(ticket)
    get_returns_or_changes(ticket)
    @ticket_total = ticket.total + @difference
    @ticket_total
  end

  def get_payments_from_individual_ticket(ticket)
    get_total_with_returns_or_changes(ticket)
    payments = []
    payments << ticket.payments_amount
    ticket.children.each do |t|
        payments << t.payments_amount
    end
    payments = payments.inject(&:+)
    payments == nil ? @payments = 0 : @payments = payments
    @ticket_total == @payments ? @pending = content_tag(:span, 'pagado', class: 'label label-success') : @pending = number_to_currency(@ticket_total - payments).to_s
    @pending
  end

  def get_payments_from_individual_order(order)
    payments = []
    order.payments.each do |payment|
      payments << payment.total
    end
    payments = payments.inject(&:+)
    payments == nil ? @payments = 0 : @payments = payments
    if @payments == 0
      @pending = content_tag(:span, 'pendiente', class: 'label label-warning')
    elsif @order_total == @payments
      @pending = content_tag(:span, 'pagado', class: 'label label-success')
    else
      @pending = number_to_currency(@ticket_total - payments).to_s
    end
    @pending
  end

  def store_name
    #REVISAR SI USO CAPITALIZE O NO#
    @store_name = current_user.store.business_unit.billing_address.business_name.split.map(&:capitalize)*' '
  end

  def prospect_rfc
    @prospect_rfc = @prospect.billing_address.rfc.upcase
  end

  def prospect_name
    #REVISAR SI USO CAPITALIZE O NO#
    @prospect_name = @prospect.billing_address.business_name.split.map(&:capitalize)*' '
  end

  def global_sat_key
    @global_key = SatKey.find_by_sat_key('01010101').sat_key
  end

  def global_unit_key
    @global_unit = SatUnitKey.find_by_unit('ACT').unit
  end

  def global_cfdi_use_key
    @global_cfdi_use_key = CfdiUse.find_by_key('P01').key
    @global_cfdi_use_key
  end

  def global_cfdi_use
    @global_cfdi_use = CfdiUse.find_by_key('P01').description
    @global_cfdi_use
  end

  def global_prospect
    @global_prospect = Prospect.find_by_legal_or_business_name('Público en General').billing_address.rfc
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

  def tax_regime_key(regime = current_user.store.business_unit.billing_address.tax_regime)
    @regime = regime.tax_id
  end

  def tax_regime(regime = current_user.store.business_unit.billing_address.tax_regime)
    @regime = regime.description
  end

  def list_of_payments
    @all_payments = []
    @objects.each do |object|
      object.payments.each do |payment|
        @all_payments << payment
      end
    end
    @all_payments
  end

end
