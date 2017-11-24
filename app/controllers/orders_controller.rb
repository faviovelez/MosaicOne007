class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show_for_store, :change_delivery_address]

  def new(role = current_user.role.name)
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       prospect: Prospect.find_by_store_prospect_id(current_user.store)
                      )
    @order.users << current_user
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (role == 'store' || role == 'store-admin')
  end

  def show
    @orders = Order.find(params[:ids].split('/'))
    @orders.each do |order|
      cost = 0
      subtotal = 0
      discount = 0
      taxes = 0
      total = 0
      if order.pending_movements == []
        order.movements.each do |mov|
          if mov.quantity == nil
            mov.delete
          else
            cost += mov.total_cost.to_f
            subtotal += mov.subtotal.to_f
            discount += mov.discount_applied.to_f
            taxes += mov.taxes.to_f
            total += mov.total.to_f
          end
        end
      else
        order.pending_movements.each do |mov|
          if mov.quantity == nil
            mov.delete
          else
            cost += mov.total_cost.to_f
            subtotal += mov.subtotal.to_f
            discount += mov.discount_applied.to_f
            taxes += mov.taxes.to_f
            total += mov.total.to_f
          end
        end
      end
      subtotal = subtotal.round(2)
      discount = discount.round(2)
      taxes = taxes.round(2)
      cost = cost.round(2)
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

  def show_for_store
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {
                    product: product,
                    images: product.images,
                    inventory: product.valid_inventory,
                   }
    else
      render json: {product: false}
    end
  end

  def _modal_product_details
    @product = params[:product]
  end

  def save_products
    status = []
    prod_req = []
    movs = []
    pend_movs = []
    @order = Order.create(store: current_user.store,
                          category: 'de línea',
                          delivery_address: current_user.store.delivery_address,
                          status: 'mercancía asignada',
                          prospect: Prospect.find_by_store_prospect_id(current_user.store)
                          )
    @order.users << current_user
    @order.save
    create_product_requests
    @order.product_requests.each do |pr|
      status << [pr.status]
      prod_req << pr
    end
    if status.uniq.length != 1
      @order.movements.each do |mov|
        movs << mov
      end
      @order.pending_movements.each do |mov|
        pend_movs << mov
      end
      @new_order = Order.create(store: current_user.store,
        category: 'de línea',
        delivery_address: current_user.store.delivery_address,
        status: 'en espera',
        prospect: Prospect.find_by_store_prospect_id(current_user.store)
      )
      assigned_mov = []
      unassigned_pr = []
      assigned_pr = []
      pendings = []
      prod_req.each do |pr|
        pend_movs.each do |pm|
          pendings << pm if (pm.product_id == pr.product_id && (pendings.include?(pm) == false))
          unassigned_pr << pr if (pm.product_id == pr.product_id && (unassigned_pr.include?(pr) == false))
        end
        movs.each do |mov|
          assigned_mov << mov if (pr.product_id == mov.product_id && (movs.include?(mov) == false))
          assigned_pr << pr if (pr.product_id == mov.product_id && (assigned_pr.include?(pr) == false))
        end
      end
      pendings.each do |pend|
        PendingMovement.find(pend.id).update(order: @new_order)
      end
      unassigned_pr.each do |pr|
        ProductRequest.find(pr.id).update(order: @new_order)
      end
    end
    @orders = []
    @orders << @order.id
    @orders << @new_order.id unless @new_order == nil
    redirect_to orders_show_path(@orders), notice: 'Todos los registros almacenados.'
  end

  def confirm
    @orders = Order.find(params[:ids].split('/'))
    @orders.each do |order|
      order.movements.each do |mov|
        mov.update(confirm: true)
      end
      order.update(confirm: true)
    end
    redirect_to store_orders_path(@orders.first.store),
      notice: 'Registros confirmados'
  end

  def change_delivery_address
    delivery = params[:order][:delivery_address]
    address = DeliveryAddress.find(delivery) unless (delivery == 'otra dirección' || delivery == 'seleccione' || delivery == '')
    notes = params[:order][:delivery_notes] unless address.present?
    if (address == nil && notes.blank?)
      redirect_to show_for_store, notice: 'Por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
    else
      if address.nil?
        @order.delivery_address = nil
      else
        @order.delivery_address = address
      end
      @order.delivery_notes = notes unless notes.nil?
      if @order.save
        redirect_to store_orders_path(current_user.store), notice: 'La dirección se actualizó correctamente.'
      else
        redirect_to show_for_store, notice: 'Hubo un error, por favor ingrese una dirección o elija otra y anote la dirección completa en el campo correspondiente.'
      end
    end
  end

  def index
    current_orders
  end

  def current_orders
    @orders = current_user.store.orders.where.not(status: ['entregada', 'cancelada', 'expirada']).order(:created_at)
  end

  def delivered_orders
    @orders = current_user.store.orders.where(status:'entregada').order(:created_at)
  end

  def history
    delivered_orders
  end

  private

  def create_product_requests
    params.select {|p| p.match('trForProduct').present? }.each do |product|
      attributes = product.second
      product = Product.find(attributes.first.second).first
      @product_request = ProductRequest.create(
        product: product,
        quantity: attributes[:order],
        order: @order,
        urgency_level: attributes[:urgency]
      )
      if @product_request.save
        if @product_request.urgency_level === 'alta'
          @product_request.update(maximum_date: attributes[:maxDate])
        end
        passing_validation
      end
    end
  end

  def passing_validation
    order_quantity = @product_request.quantity
    inventory = @product_request.product.inventory
    @product_request.update(order: @order)
    if order_quantity > inventory.fix_quantity
      @product_request.update(status: 'sin asignar')
      q = @product_request.quantity
      mov = create_movement(PendingMovement)
      mov.update(
        quantity: q,
        taxes: q * mov.taxes,
        subtotal: q * mov.subtotal,
        discount_applied: q * mov. discount_applied,
        automatic_discount: q * mov. discount_applied,
        total: (q * mov.subtotal) - (q * mov. discount_applied) + (q * mov.taxes)
      )
    else
      Movement.initialize_with(
        @product_request,
        current_user,
        'venta'
        )
      @product_request.update(status: 'asignado')
      # VALIDAR POR QUÉ DA ERROR (revisar si todavía da error)#
      movement = Movement.last
      movement.process_extras(order_type, @product_request.quantity, @order)
    end
  end

  def create_movement(object)
    product = @product_request.product
    store = current_user.store
    prospect = Prospect.find_by_store_prospect_id(store)
    discount = 0.35
    disc_app = product.price * discount
    unit_price = product.price * (1 - discount)
    movement = object.create(
      product: product,
      order: @order,
      unique_code: product.unique_code,
      store: store,
      initial_price: product.price,
      automatic_discount: disc_app,
      discount_applied: disc_app,
      final_price: unit_price,
      movement_type: 'venta',
      user: current_user,
      total: product.price,
      taxes: unit_price * 0.16,
      subtotal: product.price,
      business_unit: store.business_unit,
      product_request: @product_request,
      maximum_date: @product_request.maximum_date,
      prospect: Prospect.find_by_store_prospect_id(current_user.store)
    )
    movement
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
