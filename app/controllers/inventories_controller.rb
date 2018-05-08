class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    filter_products
  end

  def products
    filter_products
  end

  def filter_products
    @products = []
    role = current_user.role.name
    @store = current_user.store
    @dc_products = Product.where(current: true, shared: true)
    if role == 'store-admin' || role == 'store'
      @store_products = Product.where(store: @store)
      if @store_products == []
        @products = @dc_products
      else
        @products = @store_products + @dc_products
      end
    else
      @products = @dc_products
    end
    @products
  end

  def select_report
    @products = []
    role = current_user.role.name
    @store = current_user.store
    Product.where(current: true, shared: true).each do |product|
      @products << ["#{product.unique_code} #{product.description}", product.id]
    end
    if role == 'store-admin' || role == 'store'
      @store_products = Product.where(store: @store)
      if @store_products != []
        @store_products.each do |p|
          @products << ["#{p.unique_code} #{p.description}", p.id]
        end
      end
    end
    @products
  end

  def order_suggestions
    filter_products
  end

  def get_report
    if params[:options] == 'Seleccionar día'
      date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
      midnight = date.midnight + 6.hours
      end_day = date.end_of_day + 6.hours
      if params[:information] == 'Movimientos de Inventario'
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: midnight..end_day, movement_type: ['alta', 'baja'], product: params[:product_list]).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: midnight..end_day, movement_type: ['alta', 'baja']).where.not(quantity: 0)
        end
      else
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: midnight..end_day, product: params[:product_list]).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: midnight..end_day).where.not(quantity: 0)
        end
      end
    elsif params[:options] == 'Mes actual'
      beginning_of = Date.today.beginning_of_month.midnight + 6.hours
      end_of = Date.today + 6.hours
      if params[:information] == 'Movimientos de Inventario'
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: beginning_of..end_of, product: params[:product_list], movement_type: ['alta', 'baja']).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: beginning_of..end_of, movement_type: ['alta', 'baja']).where.not(quantity: 0)
        end
      else
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: beginning_of..end_of, product: params[:product_list]).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: beginning_of..end_of).where.not(quantity: 0)
        end
      end
    else
      initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
      final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
      if params[:information] == 'Movimientos de Inventario'
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list], movement_type: ['alta', 'baja']).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja']).where.not(quantity: 0)
        end
      else
        if params[:products] == 'Elegir producto'
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
        else
          movements = StoreMovement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date).where.not(quantity: 0)
        end
      end
    end
    if movements == []
      redirect_to root_path, alert: 'La fecha seleccionada no tiene registros, por favor elija otra'
    else
      @movements = movements.order(:id)
      render 'show_product_movements'
    end
  end

end
