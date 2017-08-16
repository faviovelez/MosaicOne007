module OrdersHelper

  def sum_prices
    @order.all_movements.map(
      &:initial_price
    ).inject(&:+)
  end
end
