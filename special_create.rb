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
    end
  end

  #<StoreSale:0x005615067715c0
   id: 2,
   store_id: 29,
   month: "1",
   year: "2018",
   cost: 10241.38,
   created_at: 2018-01-02 17:27:11 -0600,
   updated_at: 2018-01-09 08:07:00 -0600,
   discount: 0.0,
   total: 26649.79,
   subtotal: 22953.39,
   taxes: 3672.4,
   quantity: 946,
   payments: 27285.51,
   expenses: nil>

   #<StoreSale:0x005637a1def998
 id: 2,
 store_id: 29,
 month: "1",
 year: "2018",
 cost: 10241.38,
 created_at: 2018-01-02 17:27:11 -0600,
 updated_at: 2018-01-09 09:47:24 -0600,
 discount: 0.0,
 total: 23884.18,
 subtotal: 20569.23,
 taxes: 3290.95,
 quantity: 946,
 payments: 27034.3,
 expenses: nil>


tickets = Ticket.find([192, 193, 194, 195, 196, 200, 201, 202, 203, 204, 205])

store = tickets.first.store

ss = StoreSale.where(store: store, month: tickets.first.created_at.month, year: tickets.first.created_at.year).first

tickets.each do |ticket|
  ss.update(total: ss.total - ticket.total, subtotal: ss.subtotal - ticket.subtotal, taxes: ss.taxes - ticket.taxes)
  ticket.payments.each do |payment|
    ss.update(payments: ss.payments - payment.total)
  end
end


tickets = Store.find(29).tickets



tickets = Store.find(29).tickets.where.not(id: [192, 193, 194, 195, 196, 200, 201, 202, 203, 204, 205, 206, 207])

to_delete = Ticket.find([192, 193, 194, 195, 196, 200, 201, 202, 203, 204, 205, 206, 207])

store = Store.find(29)

ss = StoreSale.where(store: store, month: tickets.first.created_at.month, year: tickets.first.created_at.year).first

ss.update(total: 0, subtotal: 0, payments: 0, taxes: 0, cost: 0, quantity: 0)

tickets.each do |ticket|
  ss.update(total: ss.total + ticket.total, subtotal: ss.subtotal + ticket.subtotal, taxes: ss.taxes + ticket.taxes)
  ticket.store_movements.each do |sm|
    ss.update(cost: ss.cost + sm.total_cost, quantity: ss.quantity + sm.quantity)
  end
  ticket.service_offereds.each do |so|
    ss.update(quantity: so.quantity)
  end
  ticket.payments.each do |payment|
    ss.update(payments: ss.payments + payment.total)
  end
end

ss.update(total: ss.total.round(2), subtotal: ss.subtotal.round(2), taxes: ss.taxes.round(2), cost: ss.cost.round(2), payments: ss.payments.round(2))

to_delete.each do |ticket|
  ticket.store_movements.each do |sm|
    sm.delete
  end
  ticket.payments.each do |pay|
    pay.delete
  end
  ticket.service_offereds.each do |so|
    so.delete
  end
  ticket.delete
end
