module ApplicationHelper

  def translate_collection(object)
    object.collection_active ? @collection_response = 'Activa' : @collection_response = 'Inactiva'
  end

  def get_sat_keys
    @sat_keys = SatKey.joins(:products).select(:sat_key, :id).distinct.pluck(:sat_key, :id)
  end

  def get_sat_unit_keys
    @sat_unit_keys = SatUnitKey.joins(:products).select(:description, :id).distinct.pluck(:description, :id)
  end

  def convert_status_payment(pay)
    if pay.payment_type == 'pago'
      @stats = 'activo'
    else
      @stats = pay.payment_type
    end
    @stats
  end

  def convert_balance(object)
    object.balance < 1 ? @balance = content_tag(:span, 'pagado', class: 'label label-success') : @balance = number_to_currency(object.balance)
    @balance
  end

  def due_date(bill)
    @due_date = bill[1].to_date + bill[8].to_i.days
  end

  def current_bill(date)
    Date.today < date ? @bill_status = content_tag(:span, 'al corriente', class: 'label label-success') : @bill_status = content_tag(:span, 'vencida', class: 'label label-warning')
  end

  def get_discount(product_request)
    if product_request.status == 'cancelada'
      @discount = 0
    else
      if product_request.movements == []
        if product_request.pending_movement.product.group
          @discount = (product_request.pending_movement.discount_applied / (product_request.pending_movement.initial_price * product_request.pending_movement.product.average) * 100).round(0)
        else
          @discount = (product_request.pending_movement.discount_applied / product_request.pending_movement.initial_price * 100).round(0)
        end
      else
        if product_request.movements.count > 1
          subtotal = 0
          discount = 0
          product_request.movements.each do |mov|
            discount += mov.discount_applied
            subtotal += mov.subtotal
          end
          @discount = (discount / subtotal * 100).round(0)
        else
          @discount = (product_request.movements.first.discount_applied / product_request.movements.first.subtotal * 100).round(0)
        end
      end
    end
    @discount.round(0)
  end

  def get_discount_for_calculate(product_request)
    if product_request.movements == []
      @discount = ((product_request.pending_movement.initial_price - product_request.pending_movement.final_price) / product_request.pending_movement.initial_price * 100).round(0)
    else
      if product_request.movements.count > 1
        subtotal = 0
        discount = 0
        product_request.movements.each do |mov|
          discount += mov.discount_applied
          subtotal += mov.subtotal
        end
        @discount = (discount / subtotal * 100).round(0)
      else
        @discount = ((product_request.movements.first.initial_price - product_request.movements.first.final_price) / product_request.movements.first.initial_price * 100).round(0)
      end
    end
    @discount.round(0)
  end

  def unit_price(product_request)
    if product_request.movements == []
      @unit = product_request.pending_movement.final_price
    else
      unit = 0
      quant = 0
      if product_request.movements.count > 1
        product_request.movements.each do |mov|
          unit += (mov.final_price * mov.quantity)
          quant += mov.quantity
        end
        @unit = (unit / quant).round(2)
      else
        @unit = product_request.movements.first.final_price
      end
    end
    @unit
  end

  def initial_unit_price(product_request)
    if product_request.movements == []
      @unit = product_request.pending_movement.initial_price
    else
      unit = 0
      quant = 0
      if product_request.movements.count > 1
        product_request.movements.each do |mov|
          unit += (mov.initial_price * mov.quantity)
          quant += mov.quantity
        end
        @unit = (unit / quant).round(2)
      else
        @unit = product_request.movements.first.initial_price
      end
    end
    @unit
  end

  def get_total_from_pr(pr, type)
    @mov_total = 0
    if pr.status == 'cancelada'
      @mov_total = 0
    else
      if type == 'total'
        if pr.movements == []
          if pr.product.group
            @mov_total = (pr.pending_movement.final_price * 1.16 * pr.quantity * pr.product.average).round(2)
          else
            @mov_total = (pr.pending_movement.final_price * 1.16 * pr.quantity).round(2)
          end
        else
          @mov_total = pr.movements.sum(:total).round(2)
        end
      else
        if pr.movements == []
          @mov_total = pr.pending_movement.quantity if pr.pending_movement != nil
        else
          @mov_total = pr.movements.sum(:quantity)
        end
      end
    end
    @mov_total
  end

  def order_discount(id)
    order = Order.find(id)
    subtotal = 0
    discount = 0
    order.pending_movements.each do |mov|
      discount += (mov.discount_applied * mov.quantity)
      subtotal += (mov.subtotal * mov.quantity)
    end
    discount += order.movements.sum(:discount_applied)
    subtotal += order.movements.sum(:subtotal)
    (discount != 0 && subtotal != 0) ? @discount = (discount / subtotal * 100).round(0) : @discount = 0
    @discount.round(0)
  end

  def order_discount_multiple(orders)
    subtotal = 0
    discount = 0
    orders.each do |order|
      order.pending_movements.each do |mov|
        discount += (mov.discount_applied * mov.quantity)
        subtotal += (mov.subtotal * mov.quantity)
      end
      order.movements.each do |mov|
        discount += mov.discount_applied
        subtotal += mov.subtotal
      end
    end
    @discount = (discount / subtotal * 100).round(0)
    @discount.round(0)
  end

  def payment_on_time(bill)
    due_date(bill)
    if bill[9] == 'BillReceived'
      bill[12] <= @due_date ? @pay_status = content_tag(:span, 'a tiempo', class: 'label label-success') : @pay_status = content_tag(:span, 'con atraso', class: 'label label-warning')
    else
      Bill.find(bill[10]).payments.last.created_at.to_date <= @due_date ? @pay_status = content_tag(:span, 'a tiempo', class: 'label label-success') : @pay_status = content_tag(:span, 'con atraso', class: 'label label-warning')
    end
  end

  def minimum_date
    if [1, 2].include?(current_user.store.id)
      @min_date = Movement.where(store_id: current_user.store.id).order(:created_at).limit(1).pluck(:created_at).first&.to_date || Date.today
    else
      @min_date = StoreMovement.where(store_id: current_user.store.id).order(:created_at).limit(1).pluck(:created_at).first&.to_date || Date.today
    end
  end

  def inventory_status(number, sales)
    @inv_desired = (current_user.store.days_inventory_desired / 30).round(2)
    if number <= (@critic * @inv_desired) && number > 0
      @inv_status = content_tag(:span, 'crítico', class: 'label label-danger')
    elsif number < @inv_desired && number > (@low * @inv_desired)
      # ajustar utilizando los meses de inventario deseados
      @inv_status = content_tag(:span, 'adecuado', class: 'label label-primary')
    elsif number <= (@low * @inv_desired) && number > (@critic * @inv_desired)
      @inv_status = content_tag(:span, 'bajo', class: 'label label-warning')
    elsif number == @inv_desired
      @inv_status = content_tag(:span, 'óptimo', class: 'label label-success')
    elsif number > @inv_desired && number.round(0) < 1000000000
      @inv_status = content_tag(:span, 'en exceso', class: 'label label-default black-default')
    elsif number.round(0) == 1000000000 || number == 0
      sales.ceil == 0 ? @inv_status = content_tag(:span, 'sin información', class: 'label label-default') : @inv_status = content_tag(:span, 'crítico', class: 'label label-danger')
    end
  end

  def store_list_for_corporate
    @store_list = Store.where(store_type: 1).order(:store_name).pluck(:store_name, :id)
  end

  def address_for_delivery(order)
    prospect = order.prospect
    if prospect.delivery_address != nil
      @address = prospect.delivery_address.street.to_s + ' ' + prospect.delivery_address.exterior_number.to_s + ' '
      @address += 'Int. ' + prospect.delivery_address.interior_number.to_s + ' ' unless prospect.delivery_address.interior_number.blank?
      @address += 'Col. ' + prospect.delivery_address.neighborhood.to_s + '.' + ' ' + prospect.delivery_address.city.to_s + ',' + ' ' + prospect.delivery_address.state.to_s
      @address = @address.split.map(&:capitalize)*' '
    else
      @address = 'No especificada'
    end
    @address
  end

  def requests_store_user_name(request)
    user = request.users.first
    @name = user.first_name + ' '
    @name += user.middle_name + ' ' if !user.middle_name.blank?
    @name += user.last_name
    @name
  end


  def warehouse_name(order)
    user = order.users.joins(:role).where('roles.name' => ['warehouse-staff', 'warehouse-admin']).first
    if user == nil
      name = content_tag(:span, 'sin asignar', class: 'label label-danger')
    else
      name = user.first_name.capitalize + " " + user.last_name.capitalize
    end
    name
  end

  def driver_name(order)
    delivery = order.delivery_attempt
    if delivery == nil
      name = content_tag(:span, 'sin asignar', class: 'label label-danger')
    else
      name = delivery.driver.first_name.capitalize + " " + delivery.driver.last_name.capitalize
    end
    name
  end

  def driver_names
    @drivers = []
    Driver.all.select("CONCAT(first_name, ' ', last_name) AS name, id").each do |driver|
      @drivers << [driver.name, driver.id]
    end
    @drivers
  end

  def order_warehouse_user(order, array = ['warehouse-staff', 'warehouse-admin'])
    user = order.users.where(role: Role.where(name: array)).first
    @name = user.first_name + ' '
    @name += user.middle_name + ' ' if !user.middle_name.blank?
    @name += user.last_name
    @name
  end

  def movement_username(movement)
    movement.user == nil ? @user = "Sin información" : @user = movement.user.first_name + ' ' + movement.user.last_name
  end

  def order_driver(order)
    user = order.delivery_attempt.driver
    @name = user.first_name + ' ' + user.last_name
    @name
  end

  def order_request_user(order)
    user = order.request_user
    @name = user.first_name + ' '
    @name += user.middle_name + ' ' if !user.middle_name.blank?
    @name += user.last_name
    @name
  end

  def order_confirm_user(order)
    user = order.confirm_user
    @name = user.first_name + ' '
    @name += user.middle_name + ' ' if !user.middle_name.blank?
    @name += user.last_name
    @name
  end

  def store_options
    @store_options = [['Todas las tiendas'], ['Tiendas y franquicias'], ['Todas las franquicias'], ['Seleccionar tiendas']]
  end

  def corporate_store_options
    @store_options = [['Todas las tiendas'], ['Seleccionar tiendas']]
  end

  def total_with_nc_and_devs(bill, total)
    bill = Bill.find(bill)
    difference = bill.children.sum(:total)
    @total = total - difference
  end

  def pay_form_translator(form)
    pay_forms = {
      "Efectivo" => 'Efectivo',
      "Cheque nominativo" => 'Cheque',
      "Transferencia electrónica de fondos" => 'Transferencia',
      "Tarjeta de crédito" => 'Tarjeta de crédito',
      "Tarjeta de débito" => 'Tarjeta de débito',
      "Por definir" => 'Venta a crédito'
    }
    @pay_form = pay_forms[form]
  end

  def pay_bill_status(id)
    (id == nil || (id != nil && Bill.find(id).status == 'cancelada')) ? @stat = true : @stat = false
  end

  def pay_bill_span(id)
    if id == nil
      @span = content_tag(:span, 'sin REP', class: 'label label-warning')
    elsif id != nil && Bill.find(id).status == 'cancelada'
      @span = content_tag(:span, 'REP cancelado', class: 'label label-danger')
    else
      @span = content_tag(:span, 'con REP', class: 'label label-success')
    end
    @span
  end

  def select_correct_date_data(arr, date)
    correct_array = arr.select{ |arr| arr[2] == date}
    correct_array == [] ? @sale = 0 : @sale = correct_array[0][1]
  end

  def compare_vs_ly(arr, actual_date, ly_date)
    actual_array = arr.select{ |arr| arr[2] == actual_date}
    actual_array == [] ? actual_sale = 0 : actual_sale = actual_array[0][1]
    ly_array = arr.select{ |arr| arr[2] == ly_date}
    ly_array == [] ? ly_sale = 0 : ly_sale = ly_array[0][1]
    if ly_sale == 0 && actual_date == 0
      @ly_comparision = 'ND'
    elsif ly_sale == 0 && actual_date != 0
      @ly_comparision = 100
    elsif actual_date == 0
      @ly_comparision = 'Sin ventas actuales'
    else
      @ly_comparision = (((actual_sale / ly_sale) - 1) * 100).round(1)
    end
  end

  def compare_vs_lm(arr, actual_date, lm_date)
    actual_array = arr.select{ |arr| arr[2] == actual_date}
    actual_array == [] ? actual_sale = 0 : actual_sale = actual_array[0][1]
    lm_array = arr.select{ |arr| arr[2] == lm_date}
    lm_array == [] ? lm_sale = 0 : lm_sale = lm_array[0][1]
    if lm_sale == 0 && actual_date == 0
      @ly_comparision = 'ND'
    elsif lm_sale == 0 && actual_date != 0
      @ly_comparision = 100
    elsif actual_date == 0
      @lm_comparision = 'Sin ventas actuales'
    else
      @lm_comparision = (((actual_sale / lm_sale) - 1) * 100).round(1)
    end
  end

  def pay_bills(id)
    bill_ids = Bill.where(pay_bill_id: id).pluck(:sequence, :folio) unless id == nil
    @bill_ids = bill_ids.map{ |arr| arr[0] + ' ' + arr[1]}.join(", ")
  end

  def pay_bill_tickets(id)
    ticket_numbers = []
    ticket_numbers = Payment.joins(:ticket).where(payment_bill_id: id).pluck('tickets.ticket_number')
    @ticket_numbers = ticket_numbers.join(", ")
  end

  def month_list
    date2 = Date.today
    if current_user.store.store_type.store_type == 'corporativo'
      date1 = Ticket.where(store_id: current_user.store.business_unit.business_group.stores.pluck(:id)).first.created_at.to_date
    else
      date1 = Ticket.where(store: current_user.store).first.created_at.to_date
    end
    months = (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
    @month_list = [date1.strftime('%m/%Y')]
    months.times do
      @month_list << (date1 += 1.month).strftime('%m/%Y')
    end
    @last = @month_list.last
    @month_list
  end

  def companies_select
    @companies = BusinessGroup.find(1).business_units.pluck(:name, :id)
  end

  def store_list
    @stores = []
    Store.joins(:store_type).where.not(store_types: {store_type: 'corporativo'}).order(:store_name).each do |store|
      @stores << [store.store_name, store.id]
    end
    @stores
  end

  def corporate_store_list
    @stores = []
    Store.joins(:store_type).where(store_types: {store_type: 'tienda propia'}).order(:store_name).each do |store|
      @stores << [store.store_name, store.id]
    end
    @stores
  end

  def show_non_blank_field(field)
    field.blank? ? @field_value = '-' : @field_value = field
    @field_value
  end

  def find_manager(request, roles = ['manager', 'director'])
    user_id = 0
    request.users.each do |user_in_request|
      if (roles.include?(user_in_request.role.name))
        user_id = user_in_request.id
      end
    end
    if user_id == 0
      @follower = content_tag(:span, 'sin asignar', class: 'label label-danger')
    else
      user = request.users.find(user_id)
      @follower = user.first_name + ' ' + user.last_name
    end
  end

  def min_date_reports(user = current_user)
    if user.store.store_type.store_type == 'corporativo'
      @min_date = Ticket.where(store_id: user.store.business_unit.business_group.stores.pluck(:id)).first.created_at.to_date
    else
      current_user.store.tickets == [] ? @min_date = Date.today : @min_date = current_user.store.tickets.order(:created_at).limit(1).pluck(:created_at).first.to_date
    end
    @min_date
  end

  def find_designer(request, role = 'designer')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
  end

  def value_of_product_type(request)
    if request.product_type == 'otro'
      @value = request.name_type
    else
      @value = request.product_type
    end
    @value
  end

  def sum_quantity(requests)
    @result = 0
    requests.each do |r|
      @result += r.quantity
    end
    @result
  end

  def sum_quantity_order(order)
    @sum = 0
    order.product_requests.where.not(status: 'cancelada').each do |pr|
      @sum += pr.quantity
    end
    @sum
  end

  def sum_quantity_multiple_orders(orders)
    @sum = 0
    orders.each do |order|
      order.product_requests.where.not(status: 'cancelada').each do |pr|
        @sum += pr.quantity
      end
    end
    @sum
  end

# Inicia la sección de métodos utilizados por formularios en Products y Requests
  def product_line_options
    options = [['seleccione', '']]
    Classification.find_each do |c|
      options << [c.name]
    end
    options
  end

  def product_type_options
    options = [['seleccione', '']]
    ProductType.find_each do |t|
      if t.product_type == 'caja'
        options << [t.product_type, class: 'box-other']
      else
        options << [t.product_type]
      end
    end
    options << ['otro', class: 'box-other']
    options
  end

  def interior_color_options
    options = []
    InteriorColor.find_each do |i|
      options << [i.name]
    end
    options
  end

  def exterior_color_options
    options = []
    ExteriorColor.find_each do |e|
      options << [e.name]
    end
    options
  end

  def main_material_options
    options = [['seleccione', '']]
    Material.find_each do |m|
      unless (m.name == 'papel arroz' || m.name == 'celofán')
        if (m.name == 'papel kraft' || m.name == 'papel bond' || m.name == 'acetato')
          options << [m.name, class: 'resistance main bolsa']
        else
          options << [m.name, class: 'resistance main caja']
        end
      end
    end
    options << ['sugerir material']
    options
  end

  def main_material_options_alter
    options = [['sugerir material']]
    Material.find_each do |m|
      unless (m.name == 'papel arroz' || m.name == 'celofán')
        if (m.name == 'papel kraft' || m.name == 'papel bond' || m.name == 'acetato')
          options << [m.name, class: 'resistance main bolsa']
        else
          options << [m.name, class: 'resistance main caja']
        end
      end
    end
    options
  end

  def main_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.find_each do |r|
      options << [r.name, class: 'main plegadizo hidden']
    end
    r_liner.find_each do |r|
      options << [r.name, class: 'main liner hidden']
    end
    r_corrugado.find_each do |r|
      options << [r.name, class: 'main corrugado hidden']
    end
    r_d_corrugado.find_each do |r|
      options << [r.name, class: 'main doble_corrugado hidden']
    end
    options << ['no aplica', class: 'main otros hidden']
    options << ['sugerir resistencia', class: 'sometimes']
    options
  end

  def main_resistance_options_alter
    options = [['sugerir resistencia']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.find_each do |r|
      options << [r.name, class: 'main plegadizo']
    end
    r_liner.find_each do |r|
      options << [r.name, class: 'main liner']
    end
    r_corrugado.find_each do |r|
      options << [r.name, class: 'main corrugado']
    end
    r_d_corrugado.find_each do |r|
      options << [r.name, class: 'main doble_corrugado']
    end
    options << ['no aplica', class: 'main otros']
    options
  end

  def design_options
    options = [['Seleccione', '']]
    DesignLike.find_each do |d|
      options << [d.name]
    end
    options << ['Sugerir armado']
    options
  end

  def design_options_alter
    options = [['Sugerir armado']]
    DesignLike.find_each do |d|
      options << [d.name]
    end
    options
  end

# Termina la sección de métodos utilizados por formularios en Products y Requests

  def get_bill_status(ticket)
    if (ticket.bill != nil && ticket.bill.status == 'creada')
      @bill_status = content_tag(:span, 'facturado', class: 'label label-success')
    elsif (ticket.bill != nil && ticket.bill.status == 'cancelada')
      @bill_status = content_tag(:span, 'fact-cancelada', class: 'label label-danger')
    else
      @bill_status = content_tag(:span, 'por facturar', class: 'label label-warning')
    end
    @bill_status
  end

  def get_bill_status_order(order)
    if (order.bill != nil && order.bill.status == 'creada')
      @bill_status = content_tag(:span, 'facturado', class: 'label label-success')
    elsif (order.bill != nil && order.bill.status == 'cancelada')
      @bill_status = content_tag(:span, 'fact-cancelada', class: 'label label-danger')
    else
      @bill_status = content_tag(:span, 'por facturar', class: 'label label-warning')
    end
    @bill_status
  end

  def user_role_options(user)
    store = user.store
    role = user.role.name
    role_options = {
      'platform-admin' => [
        ['Administrador de plataforma', 1],
        ['Jefe de tienda', 5],
        ['Auxiliar de Tienda', 4],
        ['Jefe de almacén', 8],
        ['Auxiliar de almacén', 9],
        ['Jefe de producto', 6],
        ['Auxiliar de producto', 7],
        ['Director', 2],
        ['Gerente', 3],
        ['Jefe de diseñadores', 11],
        ['Diseñador', 12],
        ['Soporte', 14],
        ['Administrativo', 10]
      ],
      'store-admin' => [['Jefe de tienda', 5], ['Auxiliar de Tienda', 4]],
      'store' => [['Auxiliar de Tienda', 4]],
      'warehouse-admin' => [['Jefe de almacén', 8], ['Auxiliar de almacén', 9]],
      'warehouse-staff' => [['Auxiliar de almacén', 9]],
      'product-admin' => [['Auxiliar de producto', 7], ['Jefe de producto', 6]],
      'product-staff' => [['Auxiliar de producto', 7]],
      'director' => [['Director', 2], ['Gerente', 3]],
      'manager' => [['Gerente', 3]],
      'designer-admin' => [['Jefe de diseñadores', 11], ['Diseñador', 12]],
      'designer' => [['Diseñador', 12]],
      'viewer' => [['Soporte', 14]],
      'admin-desk' => [['Administrativo', 10]]
    }
    @role_options = role_options[role]
  end

  def user_store_options(user)
    if user.role.name == 'platform-admin'
      @store_options = []
      Store.all.each do |store|
        @store_options << [store.store_name, store.id]
      end
    else
      @store_options = [[user.store.store_name, user.store.id]]
    end
    @store_options
  end


# Aquí inicia la sección para los documentos de Request (pedido - authorisation_doc y cotización - estimate_doc)

  def product_info(request)
    if request.product_type == 'caja'
      @product = request.product_type.capitalize + ' tipo ' + @product = request.design_like.capitalize
    elsif request.product_type == 'otro'
      @product = request.name_type.capitalize
    else
      @product = request.product_type.capitalize
    end
    request.has_window ? @product += 'con ventana, ' : @product += ', '
    @product
  end

  def measures_info(request)
    if request.outer_length.present?
      @measures = ' medidas:' + ' ' + request.outer_length.to_s + ' ' + 'x' + ' ' + request.outer_width.to_s + ' ' + 'x' + ' ' + request.outer_height.to_s + ' ' + 'cm' + ','
    elsif request.inner_length.present?
      @measures =  ' medidas internas:' + ' ' + request.inner_length.to_s + ' ' + 'x' + ' ' + request.inner_width.to_s + ' ' + 'x' + ' ' + request.inner_height.to_s + ' ' + 'cm' + ','
    elsif (request.inner_length.present? && request.outer_length.present?)
      @measures =  ' medidas internas:' + ' ' + request.inner_length.to_s + ' ' + 'x' + ' ' + request.inner_width.to_s + ' ' + 'x' + ' ' + request.inner_height.to_s + ' ' + 'cm' + ','
    elsif request.bag_length.present?
      @measures =  ' medidas:' + ' ' + request.bag_length.to_s + ' ' + 'x' + ' ' + request.bag_width.to_s + ' ' + 'x' + ' ' + request.bag_height.to_s + ' ' + 'cm' + ','
    elsif request.exhibitor_height.present?
      @measures =  ' medidas:' + ' ' + request.exhibitor_height.to_s + ' ' + 'x' + ' ' + request.tray_quantity.to_s + ' ' + 'x' + ' ' + request.tray_length.to_s + ' ' + 'x' + ' ' + request.tray_width.to_s + 'x' + request.tray_divisions.to_s + ' ' + 'cm' + ','
    end
    @measures
  end

  def material_info(request)
    @material = 'en ' + request.main_material.capitalize
    if request.resistance_main_material == 'No aplica'
      @material += ','
    else
      @material += ',' + ' ' 'resistencia ' + request.resistance_main_material + ','
    end
  end

  def impression_info(request)
    @impression = ''
    if request.impression == 'si'
      if (request.impression_finishing == ['Sin acabados'] || request.impression_finishing == [])
        @impression = " con impresión a #{request.inks} tintas en #{request.impression_where}."
      else
        if !(request.impression_finishing == ['Sin acabados'] || request.impression_finishing == [])
          @impression = " con impresión a #{request.inks} tintas en #{request.impression_where}"
          if request.impression_finishing.length > 1
            @impression += ' con '
            request.impression_finishing.each_with_index do |val, index|
              if index == 0
                @impression += val
                @impression += ' y '
              else
                @impression += val
              end
            end
          else
            @impression += ' con '
            @impression += request.impression_finishing.first
          end
        end
      end
    else
      @impression = ' sin impresión.'
    end
    @impression
  end

  def description(request)
    product_info(request)
    measures_info(request)
    material_info(request)
    impression_info(request)
    @description = @product.to_s + ' ' + @measures.to_s + ' ' + @material.to_s + ' ' + @impression.to_s
  end

  def username(request)
    roles = ['store', 'store-admin', 'admin-desk']
    user = request.users.joins(:role).where('roles.name' => roles).first
    user_name = user.first_name.capitalize
    user_name += ' ' + user.middle_name.capitalize unless user.middle_name.blank?
    user_name += ' ' + user.last_name.capitalize unless user.last_name.capitalize.blank?
    @user_name = user_name
  end

  def request_address(request)
    @address = request.store.delivery_address.street + ' ' + request.store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + request.store.delivery_address.interior_number + ' ' unless request.store.delivery_address.interior_number.blank?
    @address += 'Col. ' + request.store.delivery_address.neighborhood + '.' + ' ' + request.store.delivery_address.city + ',' + ' ' + request.store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
  end

  def impression_finishing_help(request)
    @string = "#{request.impression_where.capitalize} a #{request.inks} tintas "
    if request.impression_finishing != []
      if @request.impression_finishing.length > 1
        @string += 'con '
        @request.impression_finishing.each_with_index do |val, index|
          if index == 0
            @string += val
            @string += ' y '
          else
            @string += val
          end
        end
      else
        @string += @request.impression_finishing.first
      end
    end
    @string
  end

  def product_total(request)
    @product_total = request.sales_price * request.quantity
  end

  def calculate_tax(request)
    @taxes = product_total(request) * 0.16
  end

  def sum_total(request)
    @total = @taxes + @product_total
  end
# Aquí finaliza la sección para los documentos de Request (pedido - authorisation_doc y cotización - estimate_doc)

def identify_kg_products(order)
  @has_kg_products = false
  @kg_options = {}
  order.movements.joins(:product).where(products: {group: true}).each do |mov|
    if @kg_options[mov.product.id] == nil
      @kg_options[mov.product.id] = []
    end
    @kg_options[mov.product.id] << ["#{mov.kg} kg"]
    @has_kg_products = true
  end
  order.pending_movements.joins(:product).where(products: {group: true}).each do |mov|
    if @kg_options[mov.product.id] == nil
      @kg_options[mov.product.id] = []
    end
    mov.quantity.times do
      @kg_options[mov.product.id] << ["#{mov.product.average} kg (estimado)"]
      @has_kg_products = true
    end
  end
  @kg_options
end

def identify_kg_products_multiple(orders)
  @has_kg_products = false
  @kg_options = {}
  orders.each do |order|
    order.movements.joins(:product).where(products: {group: true}).each do |mov|
      if @kg_options[mov.product.id] == nil
        @kg_options[mov.product.id] = []
      end
      @kg_options[mov.product.id] << ["#{mov.kg} kg"]
      @has_kg_products = true
    end
    order.pending_movements.joins(:product).where(products: {group: true}).each do |mov|
      if @kg_options[mov.product.id] == nil
        @kg_options[mov.product.id] = []
      end
      mov.quantity.times do
        @kg_options[mov.product.id] << ["#{mov.product.average} kg (estimado)"]
        @has_kg_products = true
      end
    end
  end
  @kg_options
end

end
