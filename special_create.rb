  subtotal = mov.subtotal
  discount = mov.discount_applied
  taxes = mov.taxes
  total = mov.total
  quantity = mov.quantity.to_i
  cost = mov.total_cost
  month = Date.today.month
  year  = Date.today.year
  store = mov.store
  if mov.movement_type == 'venta'
    if ProductSale.where(month: Date.today.month, year: Date.today.year, store: store, product: mov.product).first.nil?
      ProductSale.create(
        subtotal: subtotal,
        discount: discount,
        taxes: taxes,
        total: total,
        cost: cost,
        quantity: quantity,
        month: month,
        store: store,
        year: year
      )
    else
      pr = ProductSale.where(month: Date.today.month, year: Date.today.year, store: store, product: mov.product).first
      subtotal = mov.subtotal.to_f
      discount = mov.discount_applied.to_f
      taxes = mov.taxes.to_f
      total = mov.total.to_f
      quantity = mov.quantity.to_i
      cost = mov.total_cost.to_f
      if mov.movement_type == 'venta'
        pr.update_attributes(
          subtotal: pr.subtotal.to_f + subtotal,
          discount: pr.discount.to_f + discount,
          taxes: pr.taxes.to_f + taxes,
          total: pr.total.to_f + total,
          cost: pr.cost.to_f + cost,
          quantity: pr.quantity.to_i + quantity,
        )
      end

      pr.update(

      )
    end
  end
