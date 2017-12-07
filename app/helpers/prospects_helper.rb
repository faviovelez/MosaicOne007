module ProspectsHelper

  def prospect_sales(prospect)
    store = current_user.store
    @sales_summaries = ProspectSale.where(store: store, prospect: prospect)
  end

  def sum_prospect_data(prospect)
    prospect_sales(prospect)
    @total = 0
    @discount = 0
    cost = 0
    @margin = 0
    @sales_summaries.each do |summary|
      @total += summary.total
      @discount += summary.discount
      cost += summary.cost
    end
    @margin = (@total - cost) / @total
    @total
    @discount
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_last_purchase_amount(prospect)
    @amount = prospect.tickets.last.total
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_last_purchase_date(prospect)
    @date = prospect.tickets.last.created_at.to_date
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_purchases_quantity(prospect)
    @purchases = prospect.tickets.count
  end

end
