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
    @movements = []
    @orders.each do |order|
      order.movements.each do |movement|
        @movements << movement
      end
      order.pending_movements.each do |movement|
        @movements << movement
      end
    end
    @movements
  end

  def get_total_from_movements(prod_req)
    prod_req_result = 0
    total = []
    @total = 0
    @order.product_requests.each do |pr|
      if pr.id == prod_req.id
        prod_req_result = pr.product_id
      end
    end
    @order.movements.each do |mov|
      total << mov if (prod_req_result == mov.product_id && (total.include?(mov) == false))
    end
    @order.pending_movements.each do |pm|
      total << pm if (prod_req_result == pm.product_id && (total.include?(pm) == false))
    end
    total.each do |mov|
      @total += mov.total
    end
    @total
  end

  def get_total
    @total = 0
    @orders.each do |order|
      @total += order.total
    end
    @total = @total.round(2)
    @total
  end

end
