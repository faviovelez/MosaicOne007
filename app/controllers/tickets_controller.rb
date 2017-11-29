class TicketsController < ApplicationController

  def index
    # Cambiar a resumen de ventas
    store = current_user.store
    @tickets = store.tickets.where(parent:nil)
  end

  def select_month
    # Temporal en lo que hago la tabla que resuma ventas y tenga mes y año para filtrar (agregar margen y descuentos)
  end

  def sales_summary
    # Temporal, usar esta lógica pero separada por mes para guardarlo en una tabla distinta
    # Cambiar después para usar como parámetro
    # Cambiar para dividir en ventas totales y ventas diseños de cartón
    store = current_user.store
    subtotal = 0
    discount = 0
    total = 0
    cost = 0
    payments = 0
    @tickets = store.tickets.where(parent:nil)
    @tickets.each do |ticket|
      total += ticket.total
      subtotal += ticket.subtotal
      discount += ticket.discount_applied
      cost += ticket.cost
      ticket.payments.each do |payment|
        payments += payment.total
      end
      ticket.children.each do |tk|
        total += tk.total
        subtotal += tk.subtotal
        discount += tk.discount_applied
        cost += tk.cost
        tk.payments.each do |pay|
          payments += pay.total
        end
      end
    end
    @total = total
    @subtotal = subtotal
    @discount_currency = discount
    @discount_percentage = @discount_currency / @total * 100
    @cost = cost * 1.16
    @payments = payments
    @margin_currency = @total - @cost
    @margin_percentage = @margin_currency / @total * 100
    @total
    @subtotal
    @discount_currency
    @discount_percentage
    @cost
    @payments
    @margin_currency
    @margin_percentage
  end

  def sales
    store = Store.find(params[:store])
    month = params[:month]
    year = params[:year]
    @tickets = store.tickets.where("DATE_TRUNC('month', created_at), DATE_TRUNC('year', created_at)" == month, year).where(tickets: {parent_id: nil})
  end

end
