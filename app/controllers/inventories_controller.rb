class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    filter_products
  end

  def products
    filter_products
  end

  def index_with_data
    if current_user.role.name == 'store-admin' || current_user.role.name == 'store'
      store_id = current_user.store.id
      store = Store.find(store_id)
    else
      params[:store].nil? ? store_id = Store.where(store_type: 1).order(:store_name).pluck(:id).first : store_id = params[:store]
      store = Store.find(store_id)
      @store_id = store_id
    end

    final_date = (Date.today - 1.month).end_of_month
    months = Store.find(store_id).months_in_inventory
    initial_date = final_date - months.month + 1.day
    initial_date_for_query = initial_date.strftime('%F %H:%M:%S')
    final_date_for_query = final_date.strftime('%F 23:59:59')

    ly_after_initial_date = (Date.today - 1.year + 1.month).beginning_of_month
    ly_after_final_date = ly_after_initial_date + months.months - 1.day
    ly_after_initial_date_for_query = ly_after_initial_date.strftime('%F %H:%M:%S')
    ly_after_final_date_for_query = ly_after_final_date.strftime('%F 23:59:59')

    if Store.where(store_type: 2).pluck(:id).include?(current_user.store.id) && (store_id  == "1" || store_id  == "2")
      if current_user.store.id == 1
        month_sales = Movement.joins('RIGHT JOIN products ON products.id = movements.product_id RIGHT JOIN inventories ON products.id = inventories.product_id').where.not(movement_type: ['alta', 'baja', 'alta automática', 'baja automática']).where(store_id: store_id).where("(movements.created_at > '#{initial_date_for_query}' AND movements.created_at < '#{final_date_for_query}') OR (movements.created_at > '#{ly_after_initial_date_for_query}' AND movements.created_at < '#{ly_after_final_date_for_query}')").order("products.id, DATE_TRUNC('month', movements.created_at)").group("products.id, products.unique_code, products.description, DATE_TRUNC('month', movements.created_at), inventories.quantity").pluck("products.id, products.unique_code, products.description, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.quantity WHEN movements.movement_type = 'venta' THEN movements.quantity ELSE 0 END), 0) as total, COUNT(DISTINCT DATE_TRUNC('month', movements.created_at)) AS months, DATE_TRUNC('month', movements.created_at) AS month, inventories.quantity")

        @grouped_stores_inventories = Inventory.joins(:product).order(:product_id).pluck(:product_id, :unique_code, :description, :quantity, :exterior_material_color, :line).group_by{ |arr| arr[0]}
      else
        month_sales = Movement.joins('RIGHT JOIN products ON products.id = movements.product_id RIGHT JOIN stores_inventories ON products.id = stores_inventories.product_id').where(stores_inventories: {store_id: store_id}).where.not(movement_type: ['alta', 'baja', 'alta automática', 'baja automática']).where(store_id: store_id).where("(movements.created_at > '#{initial_date_for_query}' AND movements.created_at < '#{final_date_for_query}') OR (movements.created_at > '#{ly_after_initial_date_for_query}' AND movements.created_at < '#{ly_after_final_date_for_query}')").order("products.id, DATE_TRUNC('month', movements.created_at)").group("products.id, products.unique_code, products.description, DATE_TRUNC('month', movements.created_at), stores_inventories.quantity").pluck("products.id, products.unique_code, products.description, COALESCE(SUM(CASE WHEN movements.movement_type = 'devolución' THEN -movements.quantity WHEN movements.movement_type = 'venta' THEN movements.quantity ELSE 0 END), 0) as total, COUNT(DISTINCT DATE_TRUNC('month', movements.created_at)) AS months, DATE_TRUNC('month', movements.created_at) AS month, stores_inventories.quantity")

        @grouped_stores_inventories = StoresInventory.joins(:product).where(store_id: store_id).order(:product_id).pluck(:product_id, :unique_code, :description, :quantity, :exterior_material_color, :line).group_by{ |arr| arr[0]}
      end

    else
      month_sales = StoreMovement.joins('RIGHT JOIN products ON products.id = store_movements.product_id RIGHT JOIN stores_inventories ON products.id = stores_inventories.product_id').where(stores_inventories: {store_id: store_id}).where.not(movement_type: ['alta', 'baja', 'alta automática', 'baja automática']).where(store_id: store_id).where("(store_movements.created_at > '#{initial_date_for_query}' AND store_movements.created_at < '#{final_date_for_query}') OR (store_movements.created_at > '#{ly_after_initial_date_for_query}' AND store_movements.created_at < '#{ly_after_final_date_for_query}')").order("products.id, DATE_TRUNC('month', store_movements.created_at)").group("products.id, products.unique_code, products.description, DATE_TRUNC('month', store_movements.created_at), stores_inventories.quantity").pluck("products.id, products.unique_code, products.description, COALESCE(SUM(CASE WHEN store_movements.movement_type = 'devolución' THEN -store_movements.quantity WHEN store_movements.movement_type = 'venta' THEN store_movements.quantity ELSE 0 END), 0) as total, COUNT(DISTINCT DATE_TRUNC('month', store_movements.created_at)) AS months, DATE_TRUNC('month', store_movements.created_at) AS month, stores_inventories.quantity")

      @grouped_stores_inventories = StoresInventory.joins(:product).where(store_id: store_id).order(:product_id).pluck(:product_id, :unique_code, :description, :quantity, :exterior_material_color, :line).group_by{ |arr| arr[0]}
    end

    products = Product.all.order(:id).pluck(:id)

    if Store.where(store_type: 2).pluck(:id).include?(current_user.store.id) && (store_id  == "1" || store_id  == "2")
      movs = Movement.where(movement_type: ['alta', 'alta automática'], store_id: current_user.store.id, product_id: products).order(:product_id).order(created_at: :desc).pluck(:product_id, :cost, :created_at)
    else
      movs = StoreMovement.where(movement_type: ['alta', 'alta automática'], store_id: store_id, product_id: products).order(:product_id).order(created_at: :desc).pluck(:product_id, :cost, :created_at)
    end

    last_movs = []
    products.each do |product|
      if movs.find{ |arr| arr[0] == product } != [] && movs.find{ |arr| arr[0] == product } != nil
        finded = movs.find{ |arr| arr[0] == product }
        if finded[1].to_f == 0
          store_type = Store.find(store_id).store_type.store_type
          if store_type == 'franquicia'
            product_finded = Product.find(product)
            cost = (product_finded.price * (1 - (product_finded.discount_for_franchises / 100))).round(2)
          elsif store_type == 'tienda propia'
            product_finded = Product.find(product)
            cost = (product_finded.price * (1 - (product_finded.discount_for_stores / 100))).round(2)
          end
          finded[1] = cost
        end
        last_movs << [finded[0], finded[1]]
      end
    end

    @grouped_stores_inventories.each do |arr|
      last_movs.find{|movs| movs[0] == arr[1][0][0]} == nil ? this_cost = 0 : this_cost = last_movs.find{|movs| movs[0] == arr[0]}[1].to_f
      total_cost = (this_cost * arr[1][0][3]).round(2)
      arr[1][0] << this_cost
      arr[1][0] << total_cost
    end
    @grouped_month_sales = month_sales.group_by{ |arr| arr[0]}

    @average_sales_arr = []
    times = (Store.find(store_id).days_inventory_desired / 30.0).to_i
    @grouped_month_sales.keys.each do |prod_id|
      q_cy = nil
      q_ly = nil
      avg_cy = 0
      avg_ly = 0
      id = @grouped_month_sales[prod_id][0][0]
      code = @grouped_month_sales[prod_id][0][1]
      desc = @grouped_month_sales[prod_id][0][2]
      quant = @grouped_month_sales[prod_id][0][6]
      sales_arr_cy = []
      sales_arr_ly = []
      @grouped_month_sales[prod_id].each do |arr|
        if arr[5].to_date >= initial_date && arr[5].to_date <= final_date
          sales_arr_cy << [arr[5].to_date.strftime('%m/%Y'), arr[3].to_i]
          q_cy = q_cy.to_i + arr[3]
        else
          sales_arr_ly << [arr[5].to_date.strftime('%m/%Y'), arr[3].to_i]
          q_ly = q_ly.to_i + arr[3]
        end
        q_cy == nil ? avg_cy = nil : avg_cy = (q_cy / months).round(2)
        q_ly == nil ? avg_ly = nil : avg_ly = (q_ly / months).round(2)
      end
      desired_cy = (times * avg_cy.to_f).round(0).ceil
      desired_ly = (times * avg_ly.to_f).round(0).ceil
      avg_cy.to_f == 0 ? mos = 999999999.999 : mos = (quant / avg_cy).to_f
      order_cy = desired_cy - quant
      order_ly = desired_ly - quant
      @average_sales_arr << [id, code, desc, avg_cy, sales_arr_cy, avg_ly, sales_arr_ly, quant, desired_cy, desired_ly, order_cy, order_ly, mos]
    end
    @low = store.reorder_point / 100
    @critic = store.critical_point / 100
    @average_sales_arr = @average_sales_arr.group_by{ |arr| arr[0]}
  end

  def filter_products
    @inventories = []
    role = current_user.role.name
    @store = current_user.store
    if (role == 'store-admin' || role == 'store')
      @dc_products = StoresInventory.includes(:product).where(store: @store, products: {current: true, shared: true})
      @store_products = StoresInventory.includes(:product).where(products: {store_id: @store}, store_id: @store.id)
      if @store_products == []
        @inventories = @dc_products
      else
        @inventories = @store_products + @dc_products
      end
    elsif (!(role == 'store-admin' || role == 'store') && current_user.store.store_type.store_type == 'corporativo' && current_user.store.id != 1)
      @inventories = StoresInventory.includes(:product).where(store: @store, products: {current: true, shared: true}).group('products.id, stores_inventories.quantity, stores_inventories.alert, stores_inventories.alert_type').order('products.id').pluck('products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, stores_inventories.quantity / products.pieces_per_package, products.pieces_per_package, stores_inventories.quantity, stores_inventories.alert, stores_inventories.alert_type')
      .map do |prod|
        prod << ProductRequest.joins(:order).where(product_id: prod[0], corporate_id: 2, status:   'asignado').where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] }).sum(:quantity)
        prod << ProductRequest.joins(:order).where(product_id: prod[0], corporate_id: 2, status: 'sin asignar').where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] }).sum(:quantity)
      end
    else
      @inventories = Inventory.includes(:product).where(products: {current: true, shared: true}).group('products.id, inventories.quantity, inventories.alert, inventories.alert_type').order('products.id').pluck('products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, inventories.quantity / products.pieces_per_package, products.pieces_per_package, inventories.quantity, inventories.alert, inventories.alert_type')
      .map do |prod|
        prod << ProductRequest.joins(:order).where(product_id: prod[0], corporate_id: 1, status: 'asignado').where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] }).sum(:quantity)
        prod << ProductRequest.joins(:order).where(product_id: prod[0], corporate_id: 1, status: 'sin asignar').where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] }).sum(:quantity)
      end
    end
    @inventories
  end

  def select_report
    products_for_report
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
        initial_date = date.midnight
        final_date = date.end_of_day + 6.hours
      elsif params[:options] == 'Mes actual'
        initial_date = Date.today.beginning_of_month.midnight
        final_date = Date.today.end_of_day + 6.hours
      else
        initial_date = Date.parse(params[:initial_date]).midnight unless (params[:initial_date] == nil || params[:initial_date] == '')
        final_date = Date.parse(params[:final_date]).end_of_day + 6.hours unless (params[:final_date] == nil || params[:final_date] == '')
      end
      if params[:information] == 'Movimientos de inventario'
        if params[:products] == 'Elegir producto'
          if current_user.store.store_type.store_type == 'corporativo'
            movements = Movement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja', 'alta automática', 'baja automática'], product: params[:product_list]).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja', 'alta automática', 'baja automática'], product: params[:product_list]).where.not(quantity: 0)
          end
        else
          if current_user.store.store_type.store_type == 'corporativo'
            movements = Movement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja', 'alta automática', 'baja automática']).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, movement_type: ['alta', 'baja', 'alta automática', 'baja automática']).where.not(quantity: 0)
          end
        end
      else
        if params[:products] == 'Elegir producto'
          if current_user.store.store_type.store_type == 'corporativo'
            movements = Movement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
          else
            movements = StoreMovement.includes(:product, :ticket).where(store: current_user.store, created_at: initial_date..final_date, product: params[:product_list]).where.not(quantity: 0)
          end
        else
          if current_user.store.store_type.store_type == 'corporativo'
            movements = Movement.includes(:product).where(store: current_user.store, created_at: initial_date..final_date).where.not(quantity: 0)
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
        if current_user.store.store_type.store_type == 'corporativo'
          if current_user.store.id == 1
            movements = Movement.find_by_sql(@corporate_query_products_string_1)
          else
            movements = Movement.find_by_sql(@corporate_query_products_string_2)
          end
        else
          movements = StoreMovement.find_by_sql(@query_products_string)
        end
      end
    elsif params[:what_final_date] == 'Hasta una fecha'
      if params[:products] == 'Elegir producto'
        if current_user.store.store_type.store_type == 'corporativo'
          if current_user.store.id == 1
            movements = Movement.find_by_sql(@corporate_query_products_string_1)
          else
            movements = Movement.find_by_sql(@corporate_query_products_string_2)
          end
        else
          movements = StoreMovement.find_by_sql(@query_products_string)
        end
      else
        if current_user.store.store_type.store_type == 'corporativo'
          if current_user.store.id == 1
            movements = Movement.find_by_sql(@corporate_query_string_1)
          else
            movements = Movement.find_by_sql(@corporate_query_string_2)
          end
        else
          movements = StoreMovement.find_by_sql(@query_string)
        end
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
    if current_user.store.store_type.store_type == 'corporativo'
      initial_date = Movement.where(store_id: store_id).order(:created_at).limit(1).pluck(:created_at).first&.to_date&.strftime('%F %H:%M:%S')
      current_user.store.id == 1 ? inventory = "inventories" : inventory = "stores_inventories"
    else
      initial_date = StoreMovement.where(store_id: store_id).order(:created_at).limit(1).pluck(:created_at).first&.to_date&.strftime('%F %H:%M:%S')
    end
    params[:date] == nil ? final_date = Date.today.strftime('%F 23:59:59') : final_date = Date.parse(params[:date]).strftime('%F 23:59:59')

    @query_string = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost FROM (SELECT store_movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.quantity WHEN movement_type = 'alta automática' THEN store_movements.quantity WHEN movement_type = 'venta' THEN -store_movements.quantity WHEN movement_type = 'devolución' THEN store_movements.quantity WHEN movement_type = 'baja' THEN -store_movements.quantity WHEN movement_type = 'baja automática' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.total_cost WHEN movement_type = 'alta automática' THEN store_movements.total_cost WHEN movement_type = 'venta' THEN -store_movements.total_cost WHEN movement_type = 'devolución' THEN store_movements.total_cost WHEN movement_type = 'baja' THEN -store_movements.total_cost WHEN movement_type = 'baja automática' THEN -store_movements.total_cost ELSE 0 END ), 0) AS total_cost FROM store_movements WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{store_id}) GROUP BY store_movements.product_id ORDER BY store_movements.product_id) AS filtered_store_movements RIGHT JOIN stores_inventories ON stores_inventories.product_id = filtered_store_movements.product_id LEFT JOIN products ON stores_inventories.product_id = products.id WHERE stores_inventories.store_id IN (#{store_id}) ORDER BY products.id"

    @corporate_query_string_1 = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost, products.price FROM (SELECT movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN movements.quantity WHEN movement_type = 'alta automática' THEN movements.quantity WHEN movement_type = 'venta' THEN -movements.quantity WHEN movement_type = 'devolución' THEN movements.quantity WHEN movement_type = 'baja' THEN -movements.quantity WHEN movement_type = 'baja automática' THEN -movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN (products.price * movements.quantity) WHEN movement_type = 'alta automática' THEN (products.price * movements.quantity) WHEN movement_type = 'venta' THEN -(products.price * movements.quantity) WHEN movement_type = 'devolución' THEN (products.price * movements.quantity) WHEN movement_type = 'baja' THEN -(products.price * movements.quantity) WHEN movement_type = 'baja automática' THEN -(products.price * movements.quantity) ELSE 0 END ), 0) AS total_cost FROM movements LEFT JOIN products ON movements.product_id = products.id WHERE movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}' AND movements.store_id IN (#{store_id}) GROUP BY movements.product_id ORDER BY movements.product_id) AS filtered_store_movements RIGHT JOIN #{inventory} ON #{inventory}.product_id = filtered_store_movements.product_id LEFT JOIN products ON #{inventory}.product_id = products.id ORDER BY products.id"

    @corporate_query_string_2 = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost, products.price FROM (SELECT movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN movements.quantity WHEN movement_type = 'alta automática' THEN movements.quantity WHEN movement_type = 'venta' THEN -movements.quantity WHEN movement_type = 'devolución' THEN movements.quantity WHEN movement_type = 'baja' THEN -movements.quantity WHEN movement_type = 'baja automática' THEN -movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN (products.price * movements.quantity) WHEN movement_type = 'alta automática' THEN (products.price * movements.quantity) WHEN movement_type = 'venta' THEN -(products.price * movements.quantity) WHEN movement_type = 'devolución' THEN (products.price * movements.quantity) WHEN movement_type = 'baja' THEN -(products.price * movements.quantity) WHEN movement_type = 'baja automática' THEN -(products.price * movements.quantity) ELSE 0 END ), 0) AS total_cost FROM movements LEFT JOIN products ON movements.product_id = products.id WHERE movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}' AND movements.store_id IN (#{store_id}) GROUP BY movements.product_id ORDER BY movements.product_id) AS filtered_store_movements RIGHT JOIN #{inventory} ON #{inventory}.product_id = filtered_store_movements.product_id LEFT JOIN products ON #{inventory}.product_id = products.id WHERE #{inventory}.store_id IN (#{store_id}) ORDER BY products.id"

    @query_products_string = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost FROM (SELECT store_movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.quantity WHEN movement_type = 'alta automática' THEN store_movements.quantity WHEN movement_type = 'venta' THEN -store_movements.quantity WHEN movement_type = 'devolución' THEN store_movements.quantity WHEN movement_type = 'baja' THEN -store_movements.quantity WHEN movement_type = 'baja automática' THEN -store_movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN store_movements.total_cost WHEN movement_type = 'alta automática' THEN store_movements.total_cost WHEN movement_type = 'venta' THEN -store_movements.total_cost WHEN movement_type = 'devolución' THEN store_movements.total_cost WHEN movement_type = 'baja' THEN -store_movements.total_cost WHEN movement_type = 'baja automática' THEN -store_movements.total_cost ELSE 0 END ), 0) AS total_cost FROM store_movements WHERE store_movements.created_at > '#{initial_date}' AND store_movements.created_at < '#{final_date}' AND store_movements.store_id IN (#{store_id}) GROUP BY store_movements.product_id ORDER BY store_movements.product_id) AS filtered_store_movements RIGHT JOIN stores_inventories ON stores_inventories.product_id = filtered_store_movements.product_id LEFT JOIN products ON stores_inventories.product_id = products.id WHERE products.id IN (#{products_id}) AND stores_inventories.store_id IN (#{store_id}) ORDER BY products.id"

    @corporate_query_products_string_1 = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost, products.price FROM (SELECT movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN movements.quantity WHEN movement_type = 'alta automática' THEN movements.quantity WHEN movement_type = 'venta' THEN -movements.quantity WHEN movement_type = 'devolución' THEN movements.quantity WHEN movement_type = 'baja' THEN -movements.quantity WHEN movement_type = 'baja automática' THEN -movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN (products.price * movements.quantity) WHEN movement_type = 'alta automática' THEN m(products.price * movements.quantity) WHEN movement_type = 'venta' THEN -(products.price * movements.quantity) WHEN movement_type = 'devolución' THEN (products.price * movements.quantity) WHEN movement_type = 'baja' THEN -(products.price * movements.quantity) WHEN movement_type = 'baja automática' THEN -(products.price * movements.quantity) ELSE 0 END ), 0) AS total_cost FROM movements LEFT JOIN products ON movements.product_id = products.id WHERE movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}' AND movements.store_id IN (#{store_id}) GROUP BY movements.product_id ORDER BY movements.product_id) AS filtered_store_movements RIGHT JOIN #{inventory} ON #{inventory}.product_id = filtered_store_movements.product_id LEFT JOIN products ON #{inventory}.product_id = products.id WHERE products.id IN (#{products_id}) ORDER BY products.id"

    @corporate_query_products_string_2 = "SELECT products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, COALESCE(filtered_store_movements.quantity, 0) AS quantity, COALESCE(filtered_store_movements.total_cost, 0) AS total_cost, products.price FROM (SELECT movements.product_id, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN movements.quantity WHEN movement_type = 'alta automática' THEN movements.quantity WHEN movement_type = 'venta' THEN -movements.quantity WHEN movement_type = 'devolución' THEN movements.quantity WHEN movement_type = 'baja' THEN -movements.quantity WHEN movement_type = 'baja automática' THEN -movements.quantity ELSE 0 END ), 0) AS quantity, COALESCE(SUM (CASE WHEN movement_type = 'alta' THEN (products.price * movements.quantity) WHEN movement_type = 'alta automática' THEN (products.price * movements.quantity) WHEN movement_type = 'venta' THEN -(products.price * movements.quantity) WHEN movement_type = 'devolución' THEN (products.price * movements.quantity) WHEN movement_type = 'baja' THEN -(products.price * movements.quantity) WHEN movement_type = 'baja automática' THEN -(products.price * movements.quantity) ELSE 0 END ), 0) AS total_cost FROM movements LEFT JOIN products ON movements.product_id = products.id WHERE movements.created_at > '#{initial_date}' AND movements.created_at < '#{final_date}' AND movements.store_id IN (#{store_id}) GROUP BY movements.product_id ORDER BY movements.product_id) AS filtered_store_movements RIGHT JOIN #{inventory} ON #{inventory}.product_id = filtered_store_movements.product_id LEFT JOIN products ON #{inventory}.product_id = products.id WHERE products.id IN (#{products_id}) AND #{inventory}.store_id IN (#{store_id}) ORDER BY products.id"
  end

  def inventory_report
  end

end
