module RequestsHelper

  def secondary_material_options
    options = [['seleccione', '']]
    Material.all.each do |m|
      if (m.name == 'papel kraft' || m.name == 'papel bond')
        options << [m.name, class: 'resistance secondary bolsa']
      elsif (m.name == 'celofán' || m.name == 'acetato')
        options << [m.name, class: 'resistance secondary']
      else
        options << [m.name, class: 'resistance secondary caja']
      end
    end
    options << ['sugerir material']
    options
  end

  def third_material_options
    options = [['seleccione', '']]
    Material.all.each do |m|
      if (m.name == 'papel kraft' || m.name == 'papel bond')
        options << [m.name, class: 'resistance third bolsa']
      elsif (m.name == 'celofán' || m.name == 'acetato')
        options << [m.name, class: 'resistance third']
      else
        options << [m.name, class: 'resistance third caja']
      end
    end
    options << ['sugerir material']
    options
  end

  def secondary_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.all.each do |r|
      options << [r.name, class: 'secondary plegadizo hidden']
    end
    r_liner.all.each do |r|
      options << [r.name, class: 'secondary liner hidden']
    end
    r_corrugado.all.each do |r|
      options << [r.name, class: 'secondary corrugado hidden']
    end
    r_d_corrugado.all.each do |r|
      options << [r.name, class: 'secondary doble_corrugado hidden']
    end
    options << ['no aplica', class: 'secondary otros hidden']
    options << ['sugerir resistencia']
    options
  end

  def third_resistance_options
    options = [['seleccione', '']]
    r_plegadizo = Resistance.where("name LIKE ?", "%pts%")
    r_liner = Resistance.where("name LIKE ?", "%grs%")
    r_corrugado = Resistance.where("name LIKE ? AND name NOT LIKE ?", "%ECT%", "%DC%")
    r_d_corrugado = Resistance.where("name LIKE ? AND name LIKE ?", "%ECT%", "%DC%")

    r_plegadizo.all.each do |r|
      options << [r.name, class: 'third plegadizo hidden']
    end
    r_liner.all.each do |r|
      options << [r.name, class: 'third liner hidden']
    end
    r_corrugado.all.each do |r|
      options << [r.name, class: 'third corrugado hidden']
    end
    r_d_corrugado.all.each do |r|
      options << [r.name, class: 'third doble_corrugado hidden']
    end
    options << ['no aplica', class: 'third otros hidden']
    options << ['sugerir resistencia']
    options
  end

  def finishing_options
    options = [['Seleccione', ''], ['Sin acabados']]
    Finishing.all.each do |f|
      options << [f.name]
    end
    options
  end

# Aquí inicia la sección para los documentos de Request (pedido - authorisation_doc y cotización - estimate_doc)

  def product_info(request)
    request.product_type == 'otro' ? @product = 'Producto: ' + request.name_type.capitalize + '.' : @product = 'Producto: ' + request.product_type.capitalize + '.'
    @product
  end

  def measures_info(request)
    if request.outer_length.present?
      @measures = 'Medidas:' + ' ' + request.outer_length.to_s + ' ' + 'x' + ' ' + request.outer_width.to_s + ' ' + 'x' + ' ' + request.outer_height.to_s + ' ' + 'cm' + '.'
    elsif request.inner_length.present?
      @measures =  'Medidas internas:' + ' ' + request.inner_length.to_s + ' ' + 'x' + ' ' + request.inner_width.to_s + ' ' + 'x' + ' ' + request.inner_height.to_s + ' ' + 'cm' + '.'
    elsif (request.inner_length.present? && request.outer_length.present?)
      @measures =  'Medidas internas:' + ' ' + request.inner_length.to_s + ' ' + 'x' + ' ' + request.inner_width.to_s + ' ' + 'x' + ' ' + request.inner_height.to_s + ' ' + 'cm' + '.'
    elsif request.bag_length.present?
      @measures =  'Medidas:' + ' ' + request.bag_length.to_s + ' ' + 'x' + ' ' + request.bag_width.to_s + ' ' + 'x' + ' ' + request.bag_height.to_s + ' ' + 'cm' + '.'
    elsif exhibitor_height.present?
      @measures =  'Medidas:' + ' ' + request.exhibitor_height.to_s + ' ' + 'x' + ' ' + request.tray_quantity.to_s + ' ' + 'x' + ' ' + request.tray_length.to_s + ' ' + 'x' + ' ' + request.tray_width.to_s + 'x' + request.tray_divisions.to_s + ' ' + 'cm' + '.'
    end
    @measures
  end

  def material_info(request)
    @material = 'Material: ' + request.main_material.capitalize
    if request.resistance_main_material == 'No aplica'
      @material += '.'
    else
      @material += ',' + ' ' 'resistencia: ' + request.resistance_main_material + '.'
    end
  end

  def impression_info(request)
    @impression = ''
    unless request.impression == 'no'
      if request.impression_finishing == 'Sin acabados'
        @impression = "Impresión a #{request.inks} tintas en #{request.impression_where}."
      else
        @impression = "Impresión a #{request.inks} tintas en #{request.impression_where} con #{request.impression_finishing}."
      end
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

  def product_total(request)
    @product_total = request.sales_price * request.quantity
  end

  def calculate_tax(request)
    @taxes = product_total(request) * 0.16
  end

  def sum_total(request)
    @total = @taxes + @product_total
  end

  def address(request)
    @address = request.store.delivery_address.street + ' ' + request.store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + request.store.delivery_address.interior_number + ' ' unless request.store.delivery_address.interior_number.blank?
    @address += 'Col. ' + request.store.delivery_address.neighborhood + '.' + ' ' + request.store.delivery_address.city + ',' + ' ' + request.store.delivery_address.state
    @address
  end

  def username(request)
    roles = ['store', 'store-admin']
    user = request.users.joins(:role).where('roles.name' => roles).first
    user_name = user.first_name.capitalize + ' ' + user.middle_name.capitalize + ' ' + user.last_name.capitalize
  end
# Aquí finaliza la sección para los documentos de Request (pedido - authorisation_doc y cotización - estimate_doc)

end
