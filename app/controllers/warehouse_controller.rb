class WarehouseController < ApplicationController
  # Este controller se utilizará para la funcionalidad de warehouse con varios modelos.
  before_action :authenticate_user!
  before_action :set_movements, only: [:show, :confirm, :show_removeds]
  before_action :set_order, only: [:prepare_order, :waiting_products, :pending_products, :show_prepared_order]

  def new_own_entry
    @movement = Movement.new
  end

  def orders
    current_orders
  end

  def current_orders
    orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store)
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.where.not(status:'cancelada').each do |pr|
        @status << pr.status
      end
      if (@status.uniq.length == 1 && @status.first == 'asignado')
        @orders << order
      end
    end
    @orders = @orders.sort_by {|obj| obj.id}
    @orders
  end

  def pending_orders
    orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store)
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.where.not(status:'cancelada').each do |pr|
        @status << pr.status
      end
      if (@status.uniq.length == 1 && @status.first == 'sin asignar')
        @orders << order
      end
    end
    @orders = @orders.sort_by {|obj| obj.id}
    @orders
  end

  def waiting_orders
    orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store)
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.where.not(status:'cancelada').each do |pr|
        @status << pr.status
      end
      if @status.uniq.length != 1
        @orders << order
      end
    end
    @orders = @orders.sort_by {|obj| obj.id}
    @orders
  end

  def ready_orders
    @orders = Order.where(status: 'preparado', corporate: current_user.store)
  end

  def sales_for_billing
    @orders = Order.joins('LEFT JOIN bills ON orders.bill_id = bills.id').where("bills.status = 'cancelada' OR orders.bill_id IS null").where(corporate: current_user.store).where.not(status: 'cancelado')
  end

  def prepare_order
    if @order.status == 'preparado'
      redirect_to warehouse_show_prepared_order_path(@order.id)
    end
  end

  def waiting_products
  end

  def pending_products
  end

  def update_order_total
    if params[:ids].present?
      @orders = Order.find(params[:ids].split('/'))
    else
      @orders = Order.where(id:params[:id])
    end
    @orders.each do |order|
      cost = 0
      subtotal = 0
      discount = 0
      taxes = 0
      total = 0
      if order.movements != []
        order.movements.each do |mov|
          if mov.quantity == nil
            mov.delete
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f
              subtotal += mov.subtotal.to_f
              discount += mov.discount_applied.to_f
              taxes += mov.taxes.to_f
              total += mov.total.to_f
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f
              subtotal -= mov.subtotal.to_f
              discount -= mov.discount_applied.to_f
              taxes -= mov.taxes.to_f
              total -= mov.total.to_f
            end
          end
        end
      end
      order.pending_movements.each do |mov|
        if mov.quantity == nil
          mov.delete
        else
          product = mov.product
          if product.group
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity * product.average
              subtotal += mov.subtotal.to_f * mov.quantity * product.average
              discount += mov.discount_applied.to_f * mov.quantity * product.average
              taxes += mov.taxes.to_f * mov.quantity * product.average
              total += (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity * product.average
              subtotal -= mov.subtotal.to_f * mov.quantity * product.average
              discount -= mov.discount_applied.to_f * mov.quantity * product.average
              taxes -= mov.taxes.to_f * mov.quantity * product.average
              total -= (mov.subtotal.to_f * mov.quantity * product.average) - (mov.discount_applied.to_f * mov.quantity * product.average) + (mov.taxes.to_f * mov.quantity * product.average)
            end
          else
            if mov.movement_type == 'venta'
              cost += mov.total_cost.to_f * mov.quantity
              subtotal += mov.subtotal.to_f * mov.quantity
              discount += mov.discount_applied.to_f * mov.quantity
              taxes += mov.taxes.to_f * mov.quantity
              total += (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            elsif mov.movement_type == 'devolución'
              cost -= mov.total_cost.to_f * mov.quantity
              subtotal -= mov.subtotal.to_f * mov.quantity
              discount -= mov.discount_applied.to_f * mov.quantity
              taxes -= mov.taxes.to_f * mov.quantity
              total -= (mov.subtotal.to_f * mov.quantity) - (mov.discount_applied.to_f * mov.quantity) + (mov.taxes.to_f * mov.quantity)
            end
          end
        end
      end
      subtotal = subtotal.round(2)
      discount = discount.round(2)
      taxes = taxes.round(2)
      cost = cost.round(2)
      total = total.round(2)
      order.update(
        subtotal: subtotal,
        discount_applied: discount,
        taxes: taxes,
        total: total,
        cost: cost
      )
    end
    orders_total = 0
    @orders.each do |order|
      orders_total += order.total
    end
    @orders_total = orders_total
  end

  def complete_preparation
    @order = Order.find(params[:order])
    @order.update(boxes: params[:boxes], status: "preparado")
    counter = params[:pr].count
    n = 0
    counter.times do
      if params[:pr][n] != ""
        ProductRequest.find(params[:pr][n]).update(alert: params[:alert][n])
      end
      n += 1
    end
    ## Posiblemente un mailer que avise del Alert
    redirect_to warehouse_show_prepared_order_path(@order.id), notice: "Se actualizó el pedido #{@order.id}."
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {
        product: product,
        images: product.images,
        inventory: product.valid_inventory
      }
    else
      render json: {product: false}
    end
  end

  def assign_driver
    order = Order.find(params[:id])
    if params[:commit] == 'Confirmar entrega a chofer'
      order.update(status: 'en ruta')
      OrderMailer.status_on_delivery(order).deliver_now
      driver = order.delivery_attempt.driver
      redirect_to warehouse_ready_orders_path, notice: "Se ha entregado a #{driver&.first_name.capitalize} #{driver&.last_name.capitalize} el pedido #{order.id} para entrega"
    else
      driver = Driver.find(params[:driver])
      DeliveryAttempt.create(driver: driver, order: order)
      redirect_to warehouse_ready_orders_path, notice: "Se ha asignado el pedido #{order.id} a #{driver&.first_name.capitalize} #{driver&.last_name.capitalize} para entrega"
    end
  end

  def show_order
    update_order_total
    @order = Order.find(params[:id])
  end

  def save_own_product
    create_movements('alta')
    redirect_to warehouse_show_path(@codes), notice: 'Todos los registros almacenados.'
  end

  def save_supplier_product
    create_movements('alta')
    attach_bill_received
    redirect_to warehouse_show_path(@codes), notice: 'Todos los registros almacenados.'
  end

  def remove_inventory
  end

  def remove_product
    create_movements('baja')
    redirect_to warehouse_show_remove_path(@codes), notice: 'Se aplicaron las bajas solicitadas correctamente.'
  end

  def show_removeds
  end

  def show
    @codes = params[:entry_codes]
  end

  def confirm
    @movements.each do |movement|
      movement.update(confirm: true)
    end

    redirect_to warehouse_index_path,
      notice: 'Registros confirmados'
  end

  def new_supplier_entry
    @movement = Movement.new
    roles = ['warehouse-staff', 'warehouse-admin', 'store', 'store-admin']
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless roles.include?(current_user.role.name)
  end

  def orders_products
    @requests = Order.find(params[:id]).product_requests.where('product_requests.status' => 'asignado')
  end

  def index
    @entries = Movement.where(cost: nil, movement_type: 'alta')
  end

  def edit
    @entry = WarehouseEntry.find(params[:id])
    @movement = @entry.movement
  end

  def destroy
    @entry = WarehouseEntry.find(params[:id])
    @movement = @entry.movement
    if @movement.warehouse_entry.destroy
      redirect_to warehouse_show_path(params[:entry_codes]), notice: 'Registro eliminado.' if @movement.destroy
    end
  end

  def form_for_movement
    @movement = Movement.find(params[:id])
    cost = params[:movement][:cost].to_f
    total_cost = cost * @movement.quantity
    @sales_related = Movement.where(entry_movement: @movement)
    @sales_related.each do |mov|
      mov.update(cost: cost, total_cost: cost * mov.quantity)
    end
    @movement.update(cost: cost, total_cost: @movement.quantity * cost)
    if @movement.save
      redirect_to warehouse_index_path, notice: 'Se guardó el costo exitosamente.'
    else
      redirect_to root_path, alert: 'No se pudo guardar el movimiento.'
    end
  end

  def assign_warehouse_admin
    @order = Order.find(params[:id])
    user = User.find(params[:order][:user_ids])
    name = user.first_name + " " + user.last_name
    @order.users << user
    if @order.save
      change_status
      redirect_to warehouse_orders_path, notice: "Se asignó el pedido a #{name}."
    else
      redirect_to warehouse_prepare_order_path(@order), alert: 'No se pudo asignar el pedido.'
    end
  end

  def assign_warehouse_staff(user = current_user)
    @order = Order.find(params[:id])
    if params[:asignar]
      @order.users << current_user
    end
    name = user.first_name + " " + user.last_name
    if @order.save
      change_status
      redirect_to warehouse_orders_path, notice: "Se asignó el pedido a #{name}."
    else
      redirect_to warehouse_prepare_order_path, alert: 'No se pudo asignar el pedido.'
    end
  end

  def change_status
    @order.status = 'preparando'
    @order.save
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def attach_entry(product, quantity)
    update_inventory(product, quantity)
    WarehouseEntry.create(
      product:  product,
      quantity: quantity
    )
  end

  def update_inventory(product, quantity)
    product.inventory.set_quantity(
      quantity
    )
  end

  def attach_bill_received
    counter = params[:id].count
    n = 0
    counter.times do
      product = Product.find(params[:id][n])
      unless params[:supplier] == nil
        if (params[:supplier][n] == nil || params[:supplier][n] == "")
          supplier = product.supplier
        else
          supplier = Supplier.find(params[:supplier][n])
        end
      end
      product = Product.find(params[:id][n])
      BillReceived.create(
        folio: params[:folio][n],
        date_of_bill: params[:date_of_bill][n],
        subtotal: params[:subtotal][n],
        taxes_rate: params[:taxes_rate][n],
        total_amount: params[:total_amount][n],
        supplier: supplier,
        product: product
      )
      n += 1
    end
  end

  def create_movements(type)
    @codes = []
    codes = []
    counter = params[:id].count
    n = 0
    counter.times do
      if params[:id][n].include?('_')
        valid_id = params[:id][n].slice(0..(params[:id][n].index('_') -1))
        product = Product.find(valid_id)
        identifier = Movement.where(product: product, movement_type: "alta").count + 1
        if params[:identifier] != nil
          identifier_value = params[:identifier][n]
        else
          identifier_value = identifier
        end
      else
        product = Product.find(params[:id][n])
      end
      quantity = params[:quantity][n].to_i
      movement = Hash.new.tap do |movement|
        if params[:reason] != nil
          movement["reason"] = params[:reason][n]
        else
          movement["reason"] = nil
        end
        if params[:kg] != nil
          movement["kg"] = params[:kg][n].to_f
        else
          movement["kg"] = nil
        end
        movement["identifier"] = identifier_value if params[:id][n].include?('_')
        movement["product"] = product
        movement["quantity"] = quantity
        movement["movement_type"] = type
        movement["user"]= current_user
        movement["unique_code"] = product.unique_code
        movement["store"] = current_user.store
        movement["business_unit"] = current_user.store.business_unit
        unless params[:supplier] == nil
          if (params[:supplier][n] == nil || params[:supplier][n] == "")
            movement["supplier"] = product.supplier
          else
            movement["supplier"] = Supplier.find(params[:supplier][n])
          end
        end
        movement["cost"] = product.cost.to_f
        if product.group
          movement["total_cost"] = (product.cost.to_f * quantity * params[:kg][n].to_f).round(2)
        else
          movement["total_cost"] = (product.cost.to_f * quantity).round(2)
        end
      end
      n += 1
      if type == 'alta'
        attach_entry(movement["product"], quantity)
        last_mov = Movement.create(movement)
        @codes << last_mov.id
      else
        codes = Movement.generate_objects(movement)
        codes.each do |code|
          @codes << code unless @codes.include?(code)
        end
      end
    end
    @codes = @codes.join('-')
  end

  def set_movements
    @movements = Movement.where(id: params[:entry_codes].split('-'))
  end
end
