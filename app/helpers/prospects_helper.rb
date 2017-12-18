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
    unless @sales_summaries == nil
      @sales_summaries.each do |summary|
        @total += summary.total.to_f
        @discount += summary.discount.to_f
        cost += summary.cost.to_f
      end
      @margin = (@total - cost) / @total unless @total == 0
      @discount
    end
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_last_purchase_amount(prospect)
    if prospect.tickets == []
      @amount = 0
    else
      @amount = prospect.tickets.last.total
    end
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_last_purchase_date(prospect)
    if prospect.tickets == []
      @date = '-'
    else
      @date = prospect.tickets.last.created_at.to_date
    end
  end

  # Estos métodos solo sirven para tiendas (falta crear los de Diseños de Cartón)
  def get_purchases_quantity(prospect)
    if prospect.tickets == []
      @purchases = 0
    else
      @purchases = prospect.tickets.count
    end
  end

end
