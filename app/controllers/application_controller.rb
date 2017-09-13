class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  def process_product_request
    @product_request.update(status: 'asignado')
    @entries = WarehouseEntry.where(
      product: @product_request.product
    ).order("created_at #{order_type}")
    #TODO logic to set error
    if process_entries
      @product_request.product.update_inventory_quantity(
        @product_request.quantity
      )
    end
  end

  def order_type
    current_user.store.cost_type.warehouse_cost_type == 'PEPS' ? 'ASC' : 'DESC'
  end

  def process_entries
    pending_order = @product_request.quantity
    @entries.each do |entry|
      if pending_order >= entry.fix_quantity
        create_movement(Movement).update_attributes(
          quantity: entry.fix_quantity,
          cost: entry.movement.fix_cost * entry.fix_quantity
        )
        pending_order -= Movement.last.fix_quantity
        entry.destroy
      else
        create_movement(Movement).update_attributes(
          quantity: pending_order,
          cost: entry.movement.fix_cost * pending_order
        )
        entry.update(quantity: (entry.fix_quantity - pending_order) )
        break
      end
    end
    true
  rescue
    return false
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


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user_params|
        user_params.permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation, :current_password)
      end

    end
end
