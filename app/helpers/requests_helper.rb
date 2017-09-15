module RequestsHelper

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

end
