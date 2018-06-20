class WarehouseController < ApplicationController
  # Este controller se utilizará para la funcionalidad de warehouse con varios modelos.
  before_action :authenticate_user!
  before_action :set_movements, only: [:show, :confirm, :show_removeds]
  before_action :set_order, only: [:prepare_order, :waiting_products, :pending_products, :show_prepared_order]

  def new_own_entry
    validate_role
    @movement = Movement.new
  end

  def orders
    current_orders
  end

  def select_product
    corporate_id = current_user.store.id
    @products = Product.joins(:product_requests).where(product_requests: {status: 'asignado', corporate_id: corporate_id}).uniq.pluck("CONCAT(unique_code, ' ', description) AS description, products.id")
  end

  def product_selected
    corporate_id = current_user.store.id
    @product_requests = ProductRequest.includes(order: [:store, :prospect]).where(status: 'asignado', corporate_id: corporate_id, product: params[:product_list])
    render 'product_requests_by_product'
  end

  def product_requests_by_product
  end

  def current_orders
    banned_prospects_validation
    orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store).where.not(prospect_id: @banned_prospects)
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
    banned_prospects_validation
    orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store)
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.where.not(status:'cancelada').each do |pr|
        @status << pr.status
      end
#      if (@status.uniq.length != 1 && order.status != 'preparado' && order.status != 'preparando')
      if @status.uniq.length != 1
        @orders << order
      end
    end
    add_orders = Order.where.not(status: ['enviado', 'entregado', 'cancelado']).where(corporate: current_user.store).where(prospect_id: @banned_prospects).where(status: ['preparando', 'preparado'])
    add_orders.each do |order|
      @orders << order unless @orders.include?(order)
    end
    @orders = @orders.sort_by {|obj| obj.id}
    @orders
  end

  def ready_orders
    banned_prospects_validation
    @orders = Order.where(status: 'preparado', corporate: current_user.store).where.not(prospect_id: @banned_prospects)
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
    validate_role
    kg_options
  end

  def validate_role
    roles = ['warehouse-staff', 'warehouse-admin', 'product-staff', 'product-admin']
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless roles.include?(current_user.role.name)
  end

  def remove_product
    create_movements('baja')
    redirect_to warehouse_show_removeds_path(@codes), notice: 'Se aplicaron las bajas solicitadas correctamente.'
  end

  def kg_options
    @kgProducts = {}
    products = Product.where(group: true)
    products.each do |product|
      if @kgProducts[product.id] == nil
        @kgProducts[product.id] = []
      end
      WarehouseEntry.where(product: product, store_id: current_user.store.id).order(:id).each do |we|
        @kgProducts[product.id] << ["#{we.movement.kg} kg" , we.movement.id]
      end
    end
    @kgProducts = @kgProducts.to_json
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
    validate_role
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
      store: current_user.store,
      product:  product,
      quantity: quantity
    )
  end

  def update_inventory(product, quantity)
    if current_user.store.id == 1
      product.inventory.set_quantity(
        quantity
      )
    else
      inventory = StoresInventory.where(product: product, store: current_user.store).first
      inventory.update(quantity: inventory.quantity.to_i + quantity)
    end
  end

  def attach_bill_received
    unless params[:supplier] == nil
      if (params[:supplier] == nil || params[:supplier] == "")
        supplier = product.supplier
      else
        supplier = Supplier.find(params[:supplier])
      end
    end
    counter = params[:id].count
    n = 0
    br = BillReceived.create(
      folio: params[:folio],
      date_of_bill: Date.parse(params[:date_of_bill]),
      store_id: current_user.store.id,
      subtotal: params[:subtotal].to_f,
      discount: params[:discount].to_f,
      payment_complete: false,
      business_unit_id: current_user.store.business_unit.id,
      subtotal_with_discount: params[:subtotal_with_discount].to_f,
      taxes: params[:total_amount].to_f - params[:subtotal].to_f,
      taxes_rate: params[:taxes_rate].to_f,
      total_amount: params[:total_amount].to_f,
      credit_days: supplier.credit_days.to_i,
      supplier: supplier
    )
    counter.times do
      product = Product.find(params[:id][n])
      br.products << product
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
        identifier = Movement.where(product: product, movement_type: "alta", store: current_user.store).count + 1
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
          if type == 'baja' && params[:kg][n].to_f != 0
            movement["kg"] = Movement.find(params[:kg][n]).kg.to_f
          elsif type == 'alta'
            movement["kg"] = params[:kg][n].to_f
          end
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
          if (params[:supplier] == nil || params[:supplier] == "")
            movement["supplier"] = product.supplier
          else
            movement["supplier"] = Supplier.find(params[:supplier])
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
