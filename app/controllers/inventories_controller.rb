class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    filter_products
  end

  def products
    filter_products
  end

  def filter_products
    @inventories = []
    role = current_user.role.name
    @store = current_user.store
    if (role == 'store-admin' || role == 'store' || (!(role == 'store-admin' || role == 'store') && current_user.store.store_type.store_type == 'corporativo' && current_user.store.id != 1))
      @dc_products = StoresInventory.includes(:product).where(store: @store, products: {current: true, shared: true})
      @store_products = StoresInventory.includes(:product).where(products: {store_id: @store})
      if @store_products == []
        @inventories = @dc_products
      else
        @inventories = @store_products + @dc_products
      end
    else
      @dc_products = Inventory.includes(:product).where(products: {current: true, shared: true})
      @inventories = @dc_products
    end
    @inventories
  end

  def select_report
    products_for_report
  end

  def products_for_report
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
    if params[:information] == 'Reporte de inventario'
      inventories_report
    else
      if params[:options] == 'Seleccionar día'
        date = Date.parse(params[:date]) unless (params[:date] == nil || params[:date] == '')
        initial_date = date.midnight + 6.hours
        final_date = date.end_of_day + 6.hours
        if params[:information] == 'Movimientos de inventario'
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja'], product: params[:product_list]).where.not(quantity: 0)
          else
            debugger
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja']).where.not(quantity: 0)
          end
        else
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date).where.not(quantity: 0)
          end
        end
      elsif params[:options] == 'Mes actual'
        initial_date = Date.today.beginning_of_month.midnight + 6.hours
        final_date = Date.today + 6.hours
        if params[:information] == 'Movimientos de inventario'
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list], movement_type: ['alta', 'baja']).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja']).where.not(quantity: 0)
          end
        else
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date).where.not(quantity: 0)
          end
        end
      else
        initial_date = Date.parse(params[:initial_date]).midnight + 6.hours unless (params[:initial_date] == nil || params[:initial_date] == '')
        final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
        if params[:information] == 'Movimientos de inventario'
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list], movement_type: ['alta', 'baja']).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja']).where.not(quantity: 0)
          end
        else
          if params[:products] == 'Elegir producto'
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date).where.not(quantity: 0)
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

  def select_inventory_report
    products_for_report
  end

  def inventories_report
    queries_and_info_for_inventory
    if params[:what_final_date] == 'Al día de hoy'
      if params[:products] == 'Elegir producto'
        movements = StoreMovement.find_by_sql(@query_products_string)
      end
    elsif params[:what_final_date] == 'Hasta una fecha'
      if params[:products] == 'Elegir producto'
        movements = StoreMovement.find_by_sql(@query_products_string)
      else
        movements = StoreMovement.find_by_sql(@query_string)
      end
    end
    if (params[:what_final_date] == 'Al día de hoy' && params[:products] == 'Todos los productos')
      redirect_to inventories_index_path
    else
      @total_cost = movements.map(&:total_cost).sum.round(2)
      @total_quantity = movements.map(&:quantity).sum
      @inventories = movements
      render 'inventory_report'
    end
  end

  ## lógica para convertir los movements en inventories sumados y agrupados
  ## Después falta consolidar ambas pantallas para reportes de inventarios

  def queries_and_info_for_inventory
    products_id = params[:product_list].join(',') if !(params[:product_list].blank?)
    store_id = Store.find(current_user.store.id).id
    initial_date = StoreMovement.where(store_id: store_id).order(:created_at).limit(1).pluck(:created_at).first.to_date.strftime('%F %H:%M:%S')
    params[:date] == nil ? final_date = Date.today.strftime('%F 23:59:59') : final_date = Date.parse(params[:date]).strftime('%F 23:59:59')

    @query_string = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost FROM (SELECT store_movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.quantity WHEN movement_type = 'alta automática' THEN store_movements.quantity WHEN movement_type = 'venta' THEN -store_movements.quantity WHEN movement_type = 'devolución' THEN store_movements.quantity WHEN movement_type = 'baja' THEN -store_movements.quantity WHEN movement_type = 'baja automática' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.total_cost WHEN movement_type = 'alta automática' THEN store_movements.total_cost WHEN movement_type = 'venta' THEN -store_movements.total_cost WHEN movement_type = 'devolución' THEN store_movements.total_cost WHEN movement_type = 'baja' THEN -store_movements.total_cost WHEN movement_type = 'baja automática' THEN -store_movements.total_cost ELSE 0 END ), 0) AS total_cost FROM store_movements WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{store_id}) GROUP BY store_movements.product_id ORDER BY store_movements.product_id) AS filtered_store_movements RIGHT JOIN stores_inventories ON stores_inventories.product_id = filtered_store_movements.product_id LEFT JOIN products ON stores_inventories.product_id = products.id WHERE stores_inventories.store_id IN (#{store_id}) ORDER BY products.id"

    @query_products_string = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost FROM (SELECT store_movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.quantity WHEN movement_type = 'alta automática' THEN store_movements.quantity WHEN movement_type = 'venta' THEN -store_movements.quantity WHEN movement_type = 'devolución' THEN store_movements.quantity WHEN movement_type = 'baja' THEN -store_movements.quantity WHEN movement_type = 'baja automática' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.total_cost WHEN movement_type = 'alta automática' THEN store_movements.total_cost WHEN movement_type = 'venta' THEN -store_movements.total_cost WHEN movement_type = 'devolución' THEN store_movements.total_cost WHEN movement_type = 'baja' THEN -store_movements.total_cost WHEN movement_type = 'baja automática' THEN -store_movements.total_cost ELSE 0 END ), 0) AS total_cost FROM store_movements WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{store_id}) GROUP BY store_movements.product_id ORDER BY store_movements.product_id) AS filtered_store_movements RIGHT JOIN stores_inventories ON stores_inventories.product_id = filtered_store_movements.product_id LEFT JOIN products ON stores_inventories.product_id = products.id WHERE products.id IN (#{products_id}) AND stores_inventories.store_id IN (#{store_id}) ORDER BY products.id"
  end

  def inventory_report
  end

end
