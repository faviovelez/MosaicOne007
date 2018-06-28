class ProductsController < ApplicationController
  # Este controller es para crear, modificar o borrar productos en catálogo, ya sea de línea o especiales (los de Request, una vez que se autorizan).
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy, :images]
  before_action :filter_warehouses, only: [:new, :edit]
  require 'csv'

  # GET /products
  # GET /products.json
  def index
    filter_products
  end

  def show_product_csv
    attributes = %w{unique_code description quantity}

    file = CSV.generate(headers: true) do |csv|
      csv << attributes

      Product.where(current: true, shared: true).each do |product|
        csv << attributes.map{ |attr| product.send(attr) }
      end
    end
    new_file = CSV.parse(file, headers: true, encoding: 'ISO-8859-1')
    File.open(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"), "w") do |file|
      file.write(new_file)
    end

    @products_file = File.read(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"))

    respond_to do |format|
      format.html
      format.csv { send_data @products_file, filename: "productos-#{Date.today}.csv" }
    end
  end

  def images
    render :images
  end

  def catalogue
    filter_products
    @products = @products.where(classification: 'de línea')
  end

  def special
    filter_products
    @products = @products.where(classification: 'especial')
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    if params[:request_id]
      @request = Request.find(params[:request_id])
    end
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json

  # El método create lo usa 'product-admin', sin embargo este controller genera un Order que debe estar asignada al usuario que creó la Request autorizada que está dando origen a este Producto, por eso el método find_user.
  def create
    if params[:request_id]
      @request = Request.find(params[:request_id])
      find_user
    end
    @product = Product.new(product_params)
    validate_store_user
    save_sat_key
    save_sat_unit_key
    params
    save_image
    respond_to do |format|
      if @product.save
        if @request
          @request.update(status: 'código asignado', product: @product)
          save_product_from_request_related_models
          format.html { redirect_to @product, notice: 'Se creó un nuevo producto y una petición de baja de productos en espera del inventario.' }
          format.json { render :show, status: :created, location: @product }
        else
          update_discount_rules
          format.html { redirect_to @product, notice: 'Se creó un nuevo producto.' }
          format.json { render :show, status: :created, location: @product }
        end
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  # Este método también lo puede usar solamente 'product-admin'. Tanto en create como en update falta agregar que pueda subir imágenes (un modelo diferente de documents).
  def update
    save_former_price
    validate_store_user
    save_sat_key
    save_sat_unit_key
    @inventory = Inventory.find_by_product_id(@product) || StoresInventory.find_by_product_id(@product)
    save_image
    respond_to do |format|
      if @product.update(product_params)
        if @inventory.is_a?(Inventory)
          @inventory.unique_code = @product.unique_code
          @inventory.save
        end
        format.html { redirect_to @product, notice: 'El producto se ha modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def filter_warehouses
    @warehouses = Warehouse.where(id: [1,2,3])
  end

  def validate_store_user
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      if (@product.rack != "" || @product.rack != nil)
        rack = @product.rack
        @product.stores_inventories.each do |si|
          si.update(rack: rack)
        end
        if (@product.level != "" || @product.level != nil)
          level = @product.level
          @product.stores_inventories.each do |si|
            si.update(level: level)
          end
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'El producto fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  def save_sat_key
    if params[:product][:sat_key_id] == ['']
      @product.sat_key = nil
    else
      if SatKey.where(id: params[:product][:sat_key_id].second) == []
        @product.sat_key = SatKey.find_by_sat_key(params[:product][:sat_key_id].second)
      else
        @product.sat_key = SatKey.find(params[:product][:sat_key_id].second)
      end
    end
  end

  def save_sat_unit_key
    if params[:product][:sat_unit_key_id] == ['']
      @product.sat_unit_key = nil
    else
      if SatUnitKey.where(id: params[:product][:sat_unit_key_id].second) == []
        @product.sat_unit_key = SatUnitKey.find_by_unit(params[:product][:sat_unit_key_id].second)
      else
        @product.sat_unit_key = SatUnitKey.find(params[:product][:sat_unit_key_id].second)
      end
    end
  end

  def save_former_price
    if params[:product][:price] != nil
      @product.update(price_was: @product.price)
    end
  end

  def get_discount_rules
    b_units = BusinessGroup.find_by_business_group_type('main').business_units
    all_rules = DiscountRule.all
    @corporate_d_rules = DiscountRule.where(business_unit: b_units)
    @stores_d_rules = all_rules - @corporate_d_rules
  end

  def update_discount_rules
    get_discount_rules
    @corporate_d_rules.each do |rule|
      unless rule.product_list.include?(@product.id.to_s)
        if rule.product_filter == 'todos los productos de línea'
            rule.product_list << @product.id.to_s unless (@product.classification == 'especial' || rule.store != @product.store)
        elsif rule.product_filter == 'seleccionar líneas de producto'
          lines = rule.line_filter
          if lines.include?(@product.line)
            rule.product_list << @product.id.to_s unless (rule.product_list.include?(@product.id.to_s) || rule.store != @product.store)
          end
        elsif rule.product_filter == 'seleccionar productos por material'
          materials = rule.material_filter
          if materials.include?(@product.main_material)
            rule.product_list << @product.id.to_s unless (rule.product_list.include?(@product.id.to_s) || rule.store != @product.store)
          end
        end
      end
      rule.save
    end
    @stores_d_rules.each do |rule|
      unless rule.product_list.include?(@product.id.to_s)
        if rule.product_filter == 'todos los productos de línea'
            rule.product_list << @product.id.to_s unless (@product.classification == 'especial' || rule.store != @product.store)
        elsif rule.product_filter == 'seleccionar líneas de producto'
          lines = rule.line_filter
          if lines.include?(@product.line)
            rule.product_list << @product.id.to_s unless (rule.product_list.include?(@product.id.to_s) || rule.store != @product.store)
          end
        elsif rule.product_filter == 'seleccionar productos por material'
          materials = rule.material_filter
          if materials.include?(@product.main_material)
            rule.product_list << @product.id.to_s unless (rule.product_list.include?(@product.id.to_s) || rule.store != @product.store)
          end
        end
      end
      rule.save
    end
  end

  def save_product_from_request_related_models
    corporate_stores = Store.where(store_type: StoreType.find_by_store_type('corporativo')).pluck(:id)
    real_price = @request.sales_price
    price = @request.internal_price
    cost = @request.internal_cost
    discount = @request.sales_price - @request.internal_price
    quantity = @request.quantity
    store_id = BusinessUnit.find(@product.business_unit_id).stores.joins(:store_type).where(store_types: {store_type: 'corporativo'}).first.id
    @order = Order.new(status: 'en espera', category: 'especial', request_user: @request.users.first,  request: @request, store: @request.store, delivery_address: current_user.store.delivery_address, cost: (cost * quantity).round(2), subtotal: (real_price * quantity).round(2), discount_applied: (discount * quantity).round(2), taxes: (price * quantity * 0.16).round(2), total: (price * quantity * 1.16).round(2))
    @pending_movement = PendingMovement.new(product: @product, quantity: @request.quantity, movement_type: 'venta', order: @order, unique_code: @product.unique_code, product_request: @product_request, buyer_user: @finded_user, store_id: store_id, initial_price: real_price, final_price: price, cost: 0, total_cost: nil, subtotal: real_price, discount_applied: discount, automatic_discount: discount, taxes: price * 0.16, total: price* 1.16)
    if corporate_stores.include?(@request.store.id)
      @order.update(prospect: @request.prospect)
      @pending_movement.update(prospect: @request.prospect)
    else
      @order.update(prospect: @request.store.store_prospect)
      @pending_movement.update(prospect: @request.store.store_prospect)
    end
    corporate = BusinessUnit.find_by_name(@product.supplier.name).stores.where(store_type: StoreType.find_by_store_type('corporativo')).first
    @order.update(corporate: corporate)
    @order.users << @finded_user
    @order.save
    @product_request = ProductRequest.create(product: @product, quantity: @request.quantity, order: @order, maximum_date: @request.delivery_date, status: 'sin asignar')
    @inventory = Inventory.create(product: @product, unique_code: @product.unique_code)
    store_inventory = StoresInventory.create(product: @product, store: @finded_user.store)
  end

  def find_user
    @finded_user = nil
    users = @request.users
    store_users = User.joins(:role).where("roles.name = ? OR roles.name = ?", "store", "store-admin")
    users.each do |user|
      store_users.each do |store_user|
        if user == store_user
          @finded_user = user
        end
      end
    end
    @finded_user
  end

  def save_image
    if params[:product][:image].present?
      params[:product][:image].each do |image|
        @product.images << Image.create(image: image, product: @product)
      end
    end
  end

  private
  # aquí es el problema
    def filter_products
      role = current_user.role.name
      @store = current_user.store
      if role == 'store-admin' || role == 'store'
        overp = Store.find(current_user.store.id).overprice / 100 + 1
        @products = Product.select("products.id, products.store_id, products.shared, products.only_measure, products.unique_code, products.description, products.exterior_color_or_design, products.line, CASE WHEN (stores_inventories.manual_price IS null OR stores_inventories.manual_price = 0) AND products.store_id IS null THEN products.price * #{overp} * 1.16 WHEN (stores_inventories.manual_price IS null OR stores_inventories.manual_price = 0) AND products.store_id IS NOT null THEN products.price * 1.16 WHEN (stores_inventories.manual_price IS NOT null OR stores_inventories.manual_price != 0) AND products.store_id IS NOT null THEN stores_inventories.manual_price * 1.16 ELSE stores_inventories.manual_price * #{overp} * 1.16 END AS product_price").joins('RIGHT JOIN stores_inventories ON products.id = stores_inventories.product_id').where(stores_inventories: {store_id: current_user.store.id}, products: {child_id: nil}).order(:id)
      else
        @products = Product.includes(:warehouse).where(current: true, shared: true).select(:id, :unique_code, :description, :exterior_color_or_design, :line, :price, :shared, :store_id, :warehouse_id, :only_measure)
      end
      @products
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @product = Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(
      :former_code,
      :unique_code,
      :description,
      :product_type,
      :exterior_material_color,
      :interior_material_color,
      :impression,
      :exterior_color_or_design,
      :main_material,
      :resistance_main_material,
      :inner_length,
      :inner_width,
      :inner_height,
      :outer_length,
      :outer_width,
      :outer_height,
      :design_type,
      :number_of_pieces,
      :accesories_kit,
      :price,
      :bag_length,
      :bag_width,
      :bag_height,
      :exhibitor_height,
      :tray_quantity,
      :tray_length,
      :tray_width,
      :tray_divisions,
      :classification,
      :line,
      :image,
      :pieces_per_package,
      :business_unit_id,
      :supplier_id,
      :store_id,
      :warehouse_id,
      :cost,
      :rack,
      :level,
      :unit,
      :current,
      :product_dependents,
      :wholesale_id,
      :retail_id,
      :sat_key_id,
      :sat_unit_key_id,
      :group,
      :average,
      :armed,
      :armed_discount,
      :discount_for_stores,
      :discount_for_franchises,
      :only_measure,
      :parent_id,
      :child_id
      )
    end

end
