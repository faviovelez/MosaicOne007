class WarehouseController < ApplicationController
  # Este controller se utilizará para la funcionalidad de warehouse con varios modelos.
  before_action :authenticate_user!

  def new_own_entry
    @movement = Movement.new
    role = Role.find_by_name('warehouse-staff')
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless current_user.role == role
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {product: product, images: product.images}
    else
      render json: {product: false}
    end
  end

  def save_own_product
    @collection = []
    params.select {|p| p.match('trForProduct').present? }.each do |product|
      attributes = product.second
      product = Product.find(attributes.first.second).first
      @collection << Movement.new(
        product: product,
        quantity:  attributes[:cantidad],
        movement_type: 'alta',
        user: current_user,
        unique_code: product.unique_code,
        store: current_user.store,
        business_unit: current_user.store.business_unit
      )
    end
    setMovements
  end

  def new_supplier_entry
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
    @entry_id = @entry.id
  end

  def orders
    @orders = Order.where(status: 'en espera')
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

  private

  def setMovements
    @collection.each do |movement|
      if movement.save
        movement.warehouse_entry = WarehouseEntry.create(
          product: movement.product,
          quantity: movement.quantity
        )
      end
    end
  end
end
