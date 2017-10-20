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
    p_address = order.prospect.delivery_address unless order.prospect.nil?
    s_address = current_user.store.delivery_address
    options << [p_address.street + " " + p_address.exterior_number, p_address.id] unless p_address.nil?
    options << [s_address.street + " " + s_address.exterior_number, s_address.id] unless s_address.nil?
    options << ['otra dirección']
  end

  def get_orders
    @product_requests = []
    @orders.each do |order|
      order.product_requests.each do |product_request|
        @product_requests << product_request
      end
    end
    @product_requests
  end

end
