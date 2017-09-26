class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :show_for_store, :confirm, :change_delivery_address]

  def new(role = current_user.role.name)
    @order = Order.new(store: current_user.store,
                       category: 'de línea',
                       status: 'en espera'
                      )
    @order.users << current_user
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (role == 'store' || role == 'store-admin')
  end

  def show
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

  def save_products
    @order = Order.create(store: current_user.store,
                          category: 'de línea',
                          delivery_address: current_user.store.delivery_address,
                          status: 'en espera'
                          )
    @order.users << current_user
    @order.save
    create_product_requests
    redirect_to orders_show_path(@order), notice: 'Todos los registros almacenados.'
  end

  def confirm
    @order.update(confirm: true)
    redirect_to store_orders_path(@order.store),
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
    @orders = current_user.store.orders.where.not(status: ['entregada', 'cancelada', 'expirada']).order(:created_at)
  end

  def history
    @orders = current_user.store.orders.where(status:'entregada').order(:created_at)
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
        passign_validation
      end
    end
  end

  def passign_validation
    order_quantity = @product_request.quantity
    inventory = @product_request.product.inventory
    @product_request.update(order: @order)
    if order_quantity > inventory.fix_quantity
      @product_request.update(status: 'sin asignar')
      create_movement(PendingMovement).update(quantity: @product_request.quantity)
    else
      Movement.initialize_with(
        @product_request,
        current_user,
        'venta'
      )
      @product_request.update(
        status: 'asignado',
        movement: Movement.last
      )
      if (@product_request.movement.process_extras(
        order_type,
        @product_request.quantity,
        @order
      ))
      end
    end
  end

  def create_movement(object)
    product = @product_request.product
    store = current_user.store
    movement = object.create(
      product: product,
      order: @order,
      unique_code: product.unique_code,
      store: store,
      initial_price: product.price,
      movement_type: 'venta',
      user: current_user,
      business_unit: store.business_unit,
      product_request_id: @product_request.id,
      maximum_date: @product_request.maximum_date
    )
    movement
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
