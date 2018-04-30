module ApplicationHelper

  def address_for_delivery(store = object.store)
    @address = store.delivery_address.street + ' ' + store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + store.delivery_address.interior_number + ' ' unless store.delivery_address.interior_number.blank?
    @address += 'Col. ' + store.delivery_address.neighborhood + '.' + ' ' + store.delivery_address.city + ',' + ' ' + store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
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
      unless (m.name == 'papel arroz' || m.name == 'celofán' || m.name == 'acetato')
        if (m.name == 'papel kraft' || m.name == 'papel bond')
          options << [m.name, class: 'resistance main bolsa']
        else
          options << [m.name, class: 'resistance main caja']
        end
      end
    end
    options << ['sugerir material']
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
    options << ['sugerir resistencia']
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

end
