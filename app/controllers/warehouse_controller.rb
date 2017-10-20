class WarehouseController < ApplicationController
  # Este controller se utilizará para la funcionalidad de warehouse con varios modelos.
  before_action :authenticate_user!
  before_action :set_movements, only: [:show, :confirm]
  before_action :set_order, only: [:prepare_order, :waiting_products, :pending_products]

  def new_own_entry
    @movement = Movement.new
  end

  def orders
    current_orders
  end

  def current_orders
    orders = Order.where.not(status: ['enviado', 'entregado'])
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.each do |pr|
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
    orders = Order.where.not(status: ['enviado', 'entregado'])
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.each do |pr|
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
    orders = Order.where.not(status: ['enviado', 'entregado'])
    @orders = []
    orders.each do |order|
      @status = []
      order.product_requests.each do |pr|
        @status << pr.status
      end
      if @status.uniq.length != 1
        @orders << order
      end
    end
    @orders = @orders.sort_by {|obj| obj.id}
    @orders
  end

  def prepare_order
  end

  def waiting_products
  end

  def pending_products
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

  def save_own_product
    create_movements('alta')
    attach_entry
    redirect_to warehouse_show_path(@codes), notice: 'Todos los registros almacenados.'
  end

  def save_supplier_product
    create_movements('alta')
    attach_entry
    attach_bill_received
    redirect_to warehouse_show_path(@codes), notice: 'Todos los registros almacenados.'
  end

  def remove_inventory
  end

  def remove_product
    create_movements('baja')
    remove_of_inventory
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
    role = Role.find_by_name('warehouse-staff') || Role.find_by_name('warehouse-admin') || Role.find_by_name('store') || Role.find_by_name('store-admin')
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless current_user.role == role
  end

  def orders_products
    @requests = Order.find(params[:id]).product_requests.where('product_requests.status' => 'asignado')
  end

  def index
    @entries = WarehouseEntry.joins(:movement).where('movements.cost' => nil)
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
    @movement.cost = params[:movement][:cost]
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
      redirect_to warehouse_prepare_order_path, alert: 'No se pudo asignar el pedido.'
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

  def attach_entry
    @collection.each do |movement|
      if movement.save
        put_inventory(movement)
        after_processed = movement.process_pendings(
          order_type, movement.quantity
        )
        if after_processed > 0
          movement.warehouse_entry = WarehouseEntry.create(
            product:  movement.product,
            quantity: after_processed
          )
        end
      end
    end
    @codes = @collection.map {|movement| movement.id}.join('-')
  end

  def put_inventory(movement)
    begin
      movement.product.inventory.set_quantity(
        movement.quantity
      )
    rescue NoMethodError
      movement.product.inventory = Inventory.create
      movement.product.inventory.set_quantity(
        movement.quantity
      )
    end
  end

  def attach_bill_received
    params.select {|p| p.match('trForProduct').present? }.each_with_index do |product, index|
      movement = @collection[index]
      info = product.second
      if movement.save
        supplier_info = info[:supplierInfo].split(',')
        supplier = Supplier.find(supplier_info.first)
        movement.update(supplier: supplier)
        BillReceived.create(
          folio: supplier_info.second,
          date_of_bill: supplier_info.third,
          subtotal: supplier_info.fourth,
          taxes_rate: supplier_info.fifth,
          total_amount: supplier_info[5],
          supplier: supplier,
          product: movement.product
        )
      end
    end
  end

  def filter_movement(movement)
    %w(id created_at updated_at).each do |deleted|
      movement.delete(deleted)
    end
    movement
  end

  def create_movements(type)
    @collection = []
    params.select {|p| p.match('trForProduct').present? }.each do |product|
      attributes = product.second
      product = Product.find(attributes.first.second).first
      @collection << Movement.new(
        product: product,
        quantity:  attributes[:cantidad],
        movement_type: type,
        user: current_user,
        unique_code: product.unique_code,
        store: current_user.store,
        business_unit: current_user.store.business_unit
      )
    end
  end

  def remove_of_inventory
    params.select {|p| p.match('trForProduct').present? }.each_with_index do |product, index|
      params    = product.second
      movement = @collection[index]
      quantity = params[:cantidad].to_i
      if movement.save
        inventory = Inventory.find_by_product_id(params[:id])
        inventory.set_quantity(quantity, '-')
        movement.convert_warehouses(order_type, quantity)
        movement.update(reason: params[:reason])
      end
    end
    @codes = @collection.map {|movement| movement.id}.join('-')
  end

  def set_movements
    @movements = Movement.where(id: params[:entry_codes].split('-'))
  end
end
