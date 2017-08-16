class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :confirm]

  def new
    role = Role.find_by_name('store') || Role.find_by_name('store-admin')
    @order = Order.new(user: current_user,
                       store: current_user.store,
                       category: 'de línea'
                      )
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless current_user.role == role
  end

  def show
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
    @order = Order.create(user: current_user,
                       store: current_user.store,
                       category: 'de línea'
                      )
    create_product_requests
    redirect_to orders_show_path(@order), notice: 'Todos los registros almacenados.'
  end

  def confirm
    @order.update(confirm: true)
    redirect_to store_orders_path(@order.store),
      notice: 'Registros confirmados'
  end

  def catalog
  end

  def special
  end

  def index
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
    if order_quantity > inventory.fix_quantity
      @product_request.update(status: 'sin asignar')
      create_movement(PendingMovement).update(quantity: @product_request.quantity)
    else
      @entries = WarehouseEntry.where(
        product: @product_request.product
      ).order("entry_number #{order_type}")
      process_entries
    end
  end

  def process_entries
    order_quantity = @product_request.quantity
    @entries.each do |entry|
      if order_quantity >= entry.quantity
        create_movement(Movement).update_attributes(
          quantity: entry.quantity,
          cost: entry.movement.fix_cost * entry.quantity
        )
        order_quantity -= Movement.last.quantity
        entry.destroy
      else
        create_movement.(PendingMovement).update_attributes(
          quantity: entry.quantity,
          cost: entry.movement.fix_cost * entry.quantity
        )
      end
    end
  end

  def create_movement(object)
    product = @product_request.product
    store = current_user.store
    movement = object.new(
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

  def order_type
    CostType.find_by_warehouse_cost_type(
      'PEPS'
    ).selected ? 'ASC' : 'DESC'
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
