module OrdersHelper

  def sum_prices
    @order.all_movements.map(
      &:initial_price
    ).inject(&:+)
  end

  def sum_quantity(order)
    @sum = 0
    order.product_requests.each do |pr|
      @sum += pr.quantity
    end
    @sum
  end

end
