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

  def delivery_options(order)
    options = [['seleccione', '']]
    p_address = order.prospect.delivery_address unless order.prospect.nil?
    s_address = current_user.store.delivery_address
    options << [p_address&.street.to_s + " " + p_address&.exterior_number.to_s, p_address.id] unless (p_address.nil? || options.include?([p_address&.street.to_s + " " + p_address&.exterior_number.to_s, p_address.id]))
    options << [s_address&.street.to_s + " " + s_address&.exterior_number.to_s, s_address.id] unless (s_address.nil? || options.include?([s_address&.street.to_s + " " + s_address&.exterior_number.to_s, s_address.id]))
    options << ['otra dirección']
  end

  def get_orders
    @movements = []
    @product_requests = []
    @orders.each do |order|
      order.movements.each do |movement|
        @movements << movement
      end
      order.pending_movements.each do |movement|
        @movements << movement
      end
      order.product_requests.each do |pr|
        @product_requests << pr
      end
    end
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
      if mov.class == Movement
        @total += mov.total
      else
        @total += (mov.total * mov.quantity)
      end
    end
    @total
  end

  def get_total_from_pr_and_movs(prod_req)
    prod_req_result = 0
    @total = 0
    @order = prod_req.order
    @order.product_requests.each do |pr|
      if pr.id == prod_req.id
        prod_req_result = pr.product_id
      end
    end
    @order.movements.each do |mov|
      @total += mov.total if prod_req_result == mov.product_id
    end
    @order.pending_movements.each do |pm|
      if pm.product.group
        tot = ((pm.total * pm.quantity * pm.product.average)).round(2)
      else
        tot = ((pm.total * pm.quantity)).round(2)
      end
      @total += tot if prod_req_result == pm.product_id
    end
    @total
  end

  def image(movement)
    movement.product.images.first.try(
      :image_url, :thumb) || 'product_thumb.png'
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
