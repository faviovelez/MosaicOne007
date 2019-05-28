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

  def massive_price_change
  end

  def change_price_process
    if params[:product_pieces] != nil
      change_product_pieces
      if (@product_undefined == nil || @product_undefined == '' || @product_undefined == [] || @product_undefined == [''])
        redirect_to root_path, notice: 'Se ha cargado la lista de piezas por paquete exitosamente.'
      else
        redirect_to root_path, alert: "No se encontraron los siguientes códigos #{@product_undefined}"
      end
    elsif params[:supplier_list] != nil
      add_suppliers
      redirect_to root_path, notice: 'Se ha cargado la lista de proveedores exitosamente.'
    elsif params["clientes_tienda1"] != nil || params["clientes_tienda2"] != nil
      add_store_customers
      redirect_to root_path, notice: 'Se ha cargado la lista de clientes exitosamente.'
    elsif params["cambios_tienda1"] != nil || params["cambios_tienda2"] != nil
      change_billing_address
      redirect_to root_path, notice: 'Se ha modificado exitosamente la lista de clientes.'
    elsif params[:patria_products] != nil
      change_to_patria_products
      if (@product_undefined == nil || @product_undefined == '' || @product_undefined == [] || @product_undefined == [''])
        redirect_to root_path, notice: 'Se ha cargado la lista de productos de Patria exitosamente.'
      else
        redirect_to root_path, alert: "No se encontraron los siguientes códigos #{@product_undefined}"
      end
    elsif params[:compresor_products] != nil
      change_to_compresor_products
      if (@product_undefined == nil || @product_undefined == '' || @product_undefined == [] || @product_undefined == [''])
        redirect_to root_path, notice: 'Se ha cargado la lista de productos de Compresor exitosamente.'
      else
        redirect_to root_path, alert: "No se encontraron los siguientes códigos #{@product_undefined}"
      end
    elsif params[:migrate_inventory] != nil
      migrate_inventory
      if (@product_undefined == nil || @product_undefined == '' || @product_undefined == [] || @product_undefined == [''])
        redirect_to root_path, notice: 'Se ha cargado la lista de productos de Patria exitosamente.'
      else
        redirect_to root_path, alert: "No se encontraron los siguientes códigos #{@product_undefined}"
      end
    elsif params[:special_products] != nil
      upload_special_products
      redirect_to root_path, notice: 'Se ha cargado la lista de productos especiales exitosamente.'
    else
      unless params[:product_list] == nil
        ListPriceChange.create(user: current_user, document_list: params[:product_list], list_type: 'price_list')
        price_list = ListPriceChange.last
        url = price_list.document_list_url
        csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
        unfinded = []
        csv.each do |row|
          product = Product.find_by_unique_code(row['cod'])
          if product.nil? || (product.classification != 'de línea' && product.store_id != current_user.store.id)
            unfinded << row['cod']
          else
            product.update(price: row['precio'].to_f.round(2))
          end
        end
        unfinded.join(", ")
        @product_undefined = unfinded
      end
      if (@product_undefined == nil || @product_undefined == '' || @product_undefined == [] || @product_undefined == [''])
        redirect_to root_path, notice: 'Se ha cargado la lista de precios exitosamente.'
      else
        redirect_to root_path, alert: "No se encontraron los siguientes códigos #{@product_undefined}"
      end
    end
  end

  def migrate_inventory
    if params[:migrate_inventory] != nil
      ListPriceChange.create(user: current_user, document_list: params[:migrate_inventory], list_type: 'migrate_inventory')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        product = Product.find_by_unique_code(row['cod'])
        if product.present?
          if row['store'].to_i == 1
            if product.group
              inventory = Inventory.where(product_id: product.id).first
              Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: 1, movement_type: 'alta', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019', kg: row['kg'].to_f, identifier: Movement.where(product: product, store: row['store'].to_i).last.identifier.to_i.next.to_s)
              inventory.update(quantity: inventory.quantity + 1)
            else
              inventory = Inventory.where(product_id: product.id).first
              if row['cant'].to_i < inventory.quantity
                result = inventory.quantity - row['cant'].to_i
                Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: result, movement_type: 'baja', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f * result, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019')
              elsif row['cant'].to_i > inventory.quantity
                result = row['cant'].to_i - inventory.quantity
                Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: result, movement_type: 'alta', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f * result, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019')
              end
              inventory.update(quantity: row['cant'].to_i)
            end
          elsif row['store'].to_i == 2
              if product.group
              inventory = StoresInventory.where(store_id: row['store'].to_i, product_id: product.id).first
              Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: 1, movement_type: 'alta', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019', kg: row['kg'].to_f, identifier: Movement.where(product: product, store: row['store'].to_i).last.identifier.to_i.next.to_s)
              inventory.update(quantity: inventory.quantity + 1)
            else
              inventory = StoresInventory.where(store_id: row['store'].to_i, product_id: product.id).first
              if row['cant'].to_i < inventory.quantity
                result = inventory.quantity - row['cant'].to_i
                Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: result, movement_type: 'baja', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f * result, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019')
              elsif row['cant'].to_i > inventory.quantity
                result = row['cant'].to_i - inventory.quantity
                Movement.create(product_id: product.id, store_id: row['store'].to_i, user_id: current_user.id, quantity: result, movement_type: 'alta', unique_code: product.unique_code, cost: product.cost.to_f, total_cost: product.cost.to_f * result, business_unit_id: Store.find(row['store'].to_i).business_unit_id, reason: 'Corrección inventario 16 abr 2019')
              end
              inventory.update(quantity: row['cant'].to_i)
            end
          end
        else
          unfinded << row['cod']
        end
      end
      unfinded.join(", ")
      @product_undefined = unfinded
    end
  end

  def upload_special_products
    ListPriceChange.create(user: current_user, document_list: params[:special_products], list_type: 'productos_especiales')
    price_list = ListPriceChange.last
    url = price_list.document_list_url
    csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      product = Product.find_or_create_by(
        unique_code: row['cod'],
        price: row['precio'],
        sat_key: SatKey.where(sat_key: row['cod_sat']).first,
        sat_unit_key: SatUnitKey.where(description: row['unit_sat']).first
      )
      unless product == nil
        product.update(
          description: row['desc'],
          current: true,
          shared: true,
          classification: "especial",
          line: "diseños especiales",
          pieces_per_package: row['pza_pp'],
          supplier: Supplier.where(name: row['proveedor']).first,
          business_unit: BusinessUnit.where(name: row['unidad_negocio']).first
        )
      end
    end
  end

  def change_to_compresor_products
    if params[:compresor_products] != nil
      ListPriceChange.create(user: current_user, document_list: params[:compresor_products], list_type: 'patria_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        product = Product.find_by_unique_code(row['cod'])
        product != nil ? product.update(business_unit_id: 2, supplier_id: 2) : unfinded << row['cod']
      end
      unfinded.join(", ")
      @product_undefined = unfinded
    end
  end

  def change_to_patria_products
    if params[:patria_products] != nil
      ListPriceChange.create(user: current_user, document_list: params[:patria_products], list_type: 'patria_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        product = Product.find_by_unique_code(row['cod'])
        product != nil ? product.update(business_unit_id: 1, supplier_id: 1) : unfinded << row['cod']
      end
      unfinded.join(", ")
      @product_undefined = unfinded
    end
  end

  def change_billing_address
    if params["cambios_tienda1"] != nil
      ListPriceChange.create(user: current_user, document_list: params["cambios_tienda1"], list_type: 'prospect_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      csv.each do |row|
        billing = BillingAddress.where(business_name: row['nombre_de_empresa_o_cliente']).first
        if billing != nil
          billing.update(
                                            {
                                              business_name: row['nombre_de_empresa_o_cliente'],
                                              rfc: row['rfc'],
                                              street: row['calle'],
                                              exterior_number: row['num_ext'],
                                              interior_number: row['num_int'],
                                              zipcode: row['cod_postal'],
                                              neighborhood: row['colonia'],
                                              city: row['ciudad'],
                                              state: row['estado'],
                                              store_id: 1
                                            }
                                          )
        else
          BillingAddress.find_or_create_by(
                                            {
                                              business_name: row['nombre_de_empresa_o_cliente'],
                                              rfc: row['rfc'],
                                              street: row['calle'],
                                              exterior_number: row['num_ext'],
                                              interior_number: row['num_int'],
                                              zipcode: row['cod_postal'],
                                              neighborhood: row['colonia'],
                                              city: row['ciudad'],
                                              state: row['estado'],
                                              store_id: 1
                                            }
                                          )
        end

        delivery = DeliveryAddress.where(street: row['calle'], exterior_number: row['num_ext'], interior_number: row['num_int']).first
        if delivery == nil
          delivery = DeliveryAddress.create(
            {
              street: row['calle'],
              exterior_number: row['num_ext'],
              interior_number: row['num_int'],
              zipcode: row['cod_postal'],
              neighborhood: row['colonia'],
              city: row['ciudad'],
              state: row['estado']
            }
          )
        else
          delivery.update(
            {
              street: row['calle'],
              exterior_number: row['num_ext'],
              interior_number: row['num_int'],
              zipcode: row['cod_postal'],
              neighborhood: row['colonia'],
              city: row['ciudad'],
              state: row['estado']
            }
          )
        end

        prospect = Prospect.where(legal_or_business_name: row['nombre_de_empresa_o_cliente']).first
        prospect.update(
                                    {
                                      legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                      prospect_type: row['giro'],
                                      contact_first_name: row['contacto_primer_nombre'],
                                      contact_middle_name: row['contacto_segundo_nombre'],
                                      contact_last_name: row['contacto_apellido_paterno'],
                                      second_last_name: row['contacto_apellido_materno'],
                                      contact_position: row['puesto_del_contacto'],
                                      direct_phone: row['tel_fijo'],
                                      extension: row['ext'],
                                      cell_phone: row['cel'],
                                      email: row['mail'],
                                      store_id: 1,
                                      billing_address: billing,
                                      delivery_address: delivery
                                    }
                                  )
      end
    elsif params["cambios_tienda2"] != nil
      ListPriceChange.create(user: current_user, document_list: params["cambios_tienda2"], list_type: 'prospect_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      csv.each do |row|
        billing = BillingAddress.where(business_name: row['nombre_de_empresa_o_cliente']).first
        if billing != nil
          billing.update(
                                            {
                                              business_name: row['nombre_de_empresa_o_cliente'],
                                              rfc: row['rfc'],
                                              street: row['calle'],
                                              exterior_number: row['num_ext'],
                                              interior_number: row['num_num'],
                                              zipcode: row['cod_postal'],
                                              neighborhood: row['colonia'],
                                              city: row['ciudad'],
                                              state: row['estado'],
                                              store_id: 2
                                            }
          )
        end
        prospect = Prospect.where(legal_or_business_name: row['nombre_de_empresa_o_cliente']).first
        prospect.update(
                                    {
                                      legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                      prospect_type: row['giro'],
                                      contact_first_name: row['contacto_primer_nombre'],
                                      contact_middle_name: row['contacto_segundo_nombre'],
                                      contact_last_name: row['contacto_apellido_paterno'],
                                      second_last_name: row['contacto_apellido_materno'],
                                      contact_position: row['puesto_del_contacto'],
                                      direct_phone: row['tel_fijo'],
                                      extension: row['ext'],
                                      cell_phone: row['cel'],
                                      email: row['mail'],
                                      store_id: 2,
                                      billing_address: billing
                                    }
        )

        delivery = prospect.delivery_address
        if delivery == nil
          DeliveryAddress.create(
                                  {
                                    street: row['calle'],
                                    exterior_number: row['num_ext'],
                                    interior_number: row['num_num'],
                                    zipcode: row['cod_postal'],
                                    neighborhood: row['colonia'],
                                    city: row['ciudad'],
                                    state: row['estado'],
                                    store_id: 2
                                  }
          )
        else
          delivery.update(
            {
              street: row['calle'],
              exterior_number: row['num_ext'],
              interior_number: row['num_num'],
              zipcode: row['cod_postal'],
              neighborhood: row['colonia'],
              city: row['ciudad'],
              state: row['estado'],
              store_id: 2
            }
          )
        end
      end
    end
  end

  def add_store_customers
    if params["clientes_tienda1"] != nil
      ListPriceChange.create(user: current_user, document_list: params["clientes_tienda1"], list_type: 'prospect_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      csv.each do |row|
        billing = BillingAddress.create(
                                          {
                                            business_name: row['nombre_de_empresa_o_cliente'],
                                            rfc: row['rfc'],
                                            street: row['calle'],
                                            exterior_number: row['num_ext'],
                                            interior_number: row['num_int'],
                                            zipcode: row['cod_postal'],
                                            neighborhood: row['colonia'],
                                            city: row['ciudad'],
                                            state: row['estado'],
                                            store_id: 1
                                          }
                                        )

        delivery = DeliveryAddress.create(
                                            {
                                              street: row['calle'],
                                              exterior_number: row['num_ext'],
                                              interior_number: row['num_int'],
                                              zipcode: row['cod_postal'],
                                              neighborhood: row['colonia'],
                                              city: row['ciudad'],
                                              state: row['estado']
                                            }
                                          )

        prospect = Prospect.create(
                                    {
                                      legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                      prospect_type: row['giro'],
                                      contact_first_name: row['contacto_primer_nombre'],
                                      contact_middle_name: row['contacto_segundo_nombre'],
                                      contact_last_name: row['contacto_apellido_paterno'],
                                      second_last_name: row['contacto_apellido_materno'],
                                      contact_position: row['puesto_del_contacto'],
                                      direct_phone: row['tel_fijo'],
                                      extension: row['ext'],
                                      cell_phone: row['cel'],
                                      email: row['mail'],
                                      store_id: 1,
                                      billing_address: billing,
                                      delivery_address: delivery
                                    }
                                  )
      end
    elsif params["clientes_tienda2"] != nil
      ListPriceChange.create(user: current_user, document_list: params["clientes_tienda2"], list_type: 'prospect_list')
      price_list = ListPriceChange.last
      url = price_list.document_list_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      csv.each do |row|
        billing = BillingAddress.create(
                                          {
                                            business_name: row['nombre_de_empresa_o_cliente'],
                                            rfc: row['rfc'],
                                            street: row['calle'],
                                            exterior_number: row['num_ext'],
                                            interior_number: row['num_num'],
                                            zipcode: row['cod_postal'],
                                            neighborhood: row['colonia'],
                                            city: row['ciudad'],
                                            state: row['estado'],
                                            store_id: 2
                                          }
        )
        prospect = Prospect.create(
                                    {
                                      legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                      prospect_type: row['giro'],
                                      contact_first_name: row['contacto_primer_nombre'],
                                      contact_middle_name: row['contacto_segundo_nombre'],
                                      contact_last_name: row['contacto_apellido_paterno'],
                                      second_last_name: row['contacto_apellido_materno'],
                                      contact_position: row['puesto_del_contacto'],
                                      direct_phone: row['tel_fijo'],
                                      extension: row['ext'],
                                      cell_phone: row['cel'],
                                      email: row['mail'],
                                      store_id: 2,
                                      billing_address: billing
                                    }
        )

        delivery = DeliveryAddress.create(
                                          {
                                            street: row['calle'],
                                            exterior_number: row['num_ext'],
                                            interior_number: row['num_num'],
                                            zipcode: row['cod_postal'],
                                            neighborhood: row['colonia'],
                                            city: row['ciudad'],
                                            state: row['estado'],
                                            store_id: 2
                                          }
        )
      end
    end
  end

  def add_suppliers
    ListPriceChange.create(user: current_user, document_list: params[:supplier_list], list_type: 'supplier_list')
    price_list = ListPriceChange.last
    url = price_list.document_list_url
    csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      corporate_stores = Store.where(store_type: StoreType.find_by_store_type('corporativo')).pluck(:id)
      corporate_stores.each do |store_id|
        supplier = Supplier.find_or_create_by(name: row['nombre_proveedor'], direct_phone: row['tel_fijo'], store_id: store_id)
      end
    end
  end

  def change_product_pieces
    ListPriceChange.create(user: current_user, document_list: params[:product_pieces], list_type: 'pieces_list')
    price_list = ListPriceChange.last
    url = price_list.document_list_url
    csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
    unfinded = []
    csv.each do |row|
      product = Product.find_by_unique_code(row['cod'])
      if product.nil? || (product.classification != 'de línea' && product.store_id != current_user.store.id)
        unfinded << row['cod']
      else
        product.update(pieces_per_package: row['pza'].to_i) unless row['pza'].to_i == 0
      end
    end
    unfinded.join(", ")
    @product_undefined = unfinded
  end

  def show_product_csv
    headers = %w{cod desc cant}
    attributes = %w{unique_code description quantity}

    file = CSV.generate(headers: true) do |csv|
      csv << headers

      Product.where(current: true, shared: true).order(:unique_code).each do |product|
        csv << attributes.map{ |attr| attr == 'quantity' ? 0 : product.send(attr) }
      end
    end
    new_file = CSV.parse(file, headers: true, encoding: 'ISO-8859-1')
    File.open(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"), "w") do |file|
      file.write(new_file)
    end

    @products_file = File.read(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"))

    respond_to do |format|
      format.csv { send_data @products_file, filename: "productos-activos-en-blanco#{Date.today}.csv" }
    end
  end

  def show_product_cost_for_stores
    headers = %w{cod desc cost}
    attributes = %w{unique_code description price_with_discount_stores}

    file = CSV.generate(headers: true) do |csv|
      csv << headers

      Product.where(current: true, shared: true).order(:unique_code).each do |product|
        csv << attributes.map{ |attr| product.send(attr) }
      end
    end

    new_file = CSV.parse(file, headers: true, encoding: 'ISO-8859-1')
    File.open(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"), "w") do |file|
      file.write(new_file)
    end

    @products_file = File.read(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"))

    respond_to do |format|
      format.csv { send_data @products_file, filename: "productos-activos-costo-tiendas-propias-#{Date.today}.csv" }
    end
  end

  def show_product_cost_for_franchises
    headers = %w{cod desc cost}
    attributes = %w{unique_code description price_with_discount_franchises}

    file = CSV.generate(headers: true) do |csv|
      csv << headers

      Product.where(current: true, shared: true).order(:unique_code).each do |product|
        csv << attributes.map{ |attr| product.send(attr) }
      end
    end
    new_file = CSV.parse(file, headers: true, encoding: 'ISO-8859-1')
    File.open(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"), "w") do |file|
      file.write(new_file)
    end

    @products_file = File.read(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"))

    respond_to do |format|
      format.csv { send_data @products_file, filename: "productos-activos-costo-franquicias-#{Date.today}.csv" }
    end
  end

  def show_product_cost_for_corporate
    headers = %w{cod desc cost}
    attributes = %w{unique_code description cost}

    file = CSV.generate(headers: true) do |csv|
      csv << headers

      Product.where(current: true, shared: true).order(:unique_code).each do |product|
        csv << attributes.map{ |attr| attr == 'cost' ? product.send(attr).to_f : product.send(attr) }
      end
    end
    new_file = CSV.parse(file, headers: true, encoding: 'ISO-8859-1')
    File.open(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"), "w") do |file|
      file.write(new_file)
    end

    @products_file = File.read(Rails.root.join("public", "uploads", "product_files", "all_stores", "productos.csv"))

    respond_to do |format|
      format.csv { send_data @products_file, filename: "productos-activos-costo-corporativo-#{Date.today}.csv" }
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
    @order = Order.new(status: 'en espera', category: 'especial', request_user: @request.users.where(role_id: [4,5,10]).first, request: @request, store: @request.store, delivery_address: current_user.store.delivery_address, cost: (cost * quantity).round(2), subtotal: (real_price * quantity).round(2), discount_applied: (discount * quantity).round(2), taxes: (price * quantity * 0.16).round(2), total: (price * quantity * 1.16).round(2))
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
    @pending_movement.update(product_request: @product_request)
    @inventory = Inventory.create(product: @product, unique_code: @product.unique_code)
    store_inventory = StoresInventory.create(product: @product, store: @finded_user.store)
  end

  def find_user
    @finded_user = nil
    users = @request.users
    store_users = User.joins(:role).where("roles.name = ? OR roles.name = ? OR roles.name = ?", "store", "store-admin", "admin-desk")
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
        @products = Product.select("products.id, products.store_id, products.shared, products.only_measure, products.unique_code, products.description, products.exterior_color_or_design, products.line, CASE WHEN (stores_inventories.manual_price IS null OR stores_inventories.manual_price = 0) AND products.store_id IS null THEN products.price * #{overp} * 1.16 WHEN (stores_inventories.manual_price IS null OR stores_inventories.manual_price = 0) AND products.store_id IS NOT null THEN products.price * 1.16 WHEN (stores_inventories.manual_price IS NOT null AND stores_inventories.manual_price != 0) AND products.store_id IS null THEN stores_inventories.manual_price * 1.16 WHEN (stores_inventories.manual_price IS NOT null AND stores_inventories.manual_price != 0) AND products.store_id IS NOT null THEN stores_inventories.manual_price * 1.16 ELSE stores_inventories.manual_price * #{overp} * 1.16 END AS product_price, stores_inventories.manual_price_update").joins('RIGHT JOIN stores_inventories ON products.id = stores_inventories.product_id').where(stores_inventories: {store_id: current_user.store.id}, products: {child_id: nil}).order(:id)
      elsif role == 'product-admin' || role == 'product-staff'
        @products = Product.joins(:warehouse, :business_unit, :supplier).select("products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, products.price, products.shared, products.store_id, products.warehouse_id, products.only_measure, suppliers.name AS supplier_name, business_units.name AS business_unit_name")
      else
        if current_user.role.name == 'admin-desk'
          @products = Product.joins(:warehouse, :business_unit, :supplier).where(current: true, shared: true).select("products.id, products.unique_code, products.description, products.exterior_color_or_design, products.line, products.price, products.shared, products.store_id, products.warehouse_id, products.only_measure, suppliers.name AS supplier_name, business_units.name AS business_unit_name")
        else
          @products = Product.includes(:warehouse).where(current: true, shared: true).select(:id, :unique_code, :description, :exterior_color_or_design, :line, :price, :shared, :store_id, :warehouse_id, :only_measure)
        end
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
      :child_id,
      :shared
      )
    end

end
