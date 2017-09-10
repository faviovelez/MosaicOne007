module OrdersHelper

  def sum_prices
    @order.all_movements.map(
      &:fix_initial_price
    ).inject(&:+)
  end

  def get_maximum_date(date)
    return '' if date.nil?
    l date
  end

  def sum_quantity(order)
    @sum = 0
    order.product_requests.each do |pr|
      @sum += pr.quantity
    end
    @sum
  end

  def delivery_options(order)
    options = [['seleccione', '']]
    p_address = order.prospect.delivery_address
    s_address = current_user.store.delivery_address
    options << [p_address.street + " " + p_address.exterior_number, p_address.id] unless p_address.nil?
    options << [s_address.street + " " + s_address.exterior_number, s_address.id] unless s_address.nil?
    options << ['otra dirección']
  end

end
