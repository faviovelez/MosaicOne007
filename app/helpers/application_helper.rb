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

  def convert_balance(object)
    object.balance < 1 ? @balance = content_tag(:span, 'pagado', class: 'label label-success') : @balance = number_to_currency(object.balance)
    @balance
  end

  def address_for_delivery(order)
    store = order.store
    @address = store.delivery_address.street + ' ' + store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + store.delivery_address.interior_number + ' ' unless store.delivery_address.interior_number.blank?
    @address += 'Col. ' + store.delivery_address.neighborhood + '.' + ' ' + store.delivery_address.city + ',' + ' ' + store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
  end

  def requests_store_user_name(request)
    user = request.users.first
    @name = user.first_name + ' '
    @name += user.middle_name if !user.middle_name.blank?
    @name += user.last_name
    @name
  end

  def show_non_blank_field(field)
    field.blank? ? @field_value = '-' : @field_value = field
    @field_value
  end

  def find_manager(request, role = 'manager' || role = 'director')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
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
    elsif exhibitor_height.present?
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
      if request.impression_finishing == ['Sin acabados']
        @impression = " con impresión a #{request.inks} tintas en #{request.impression_where}."
      else
        if request.impression_finishing != ['Sin acabados']
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
    @description = @product + ' ' + @measures + ' ' + @material + ' ' + @impression
  end

  def username(request)
    roles = ['store', 'store-admin']
    user = request.users.joins(:role).where('roles.name' => roles).first
    user_name = user.first_name.capitalize
    user_name += ' ' + user.middle_name.capitalize unless user.middle_name.blank?
    user_name += ' ' + user.last_name.capitalize unless user.last_name.capitalize.blank?
    @user_name =user_name
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

end
