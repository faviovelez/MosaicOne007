class StoresController < ApplicationController
  # En este se crean nuevas tiendas (solo el usuario de product-admin deberá poder crearlas y un user 'store' solo podrá modificarlas (algunas modificaciones estarán restringidas)
  before_action :authenticate_user!
  before_action :set_store, only: [:show, :edit, :update, :show_settings, :settings, :download_products_example, :download_prospects_example]
  before_action :allow_only_platform_admin_role, only: :new
#  before_action :allow_store_admin_or_platform_admin_role, only: :edit

  require 'csv'
  require 'open-uri'

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
  end

  def edit
  end

  def new
    @store = Store.new
  end

  def settings
  end

  def show_settings
  end

  def upload_info
    @store = current_user.store
  end

  def download_products_example
    redirect_to "#{Rails.root}/public/example_files/inventarios.csv"
  end

  def download_prospects_example
    redirect_to "#{Rails.root}/public/example_files/clientes.csv"
  end

  def generate_products_example
  end

  def generate_prospects_example
  end

  def create
    get_last_series
    @store = Store.new(store_params)
############################################################
#CAMBIAR ESTA LÓGICA AL TENER UN BUSCADOR CON AJAX
#    zip_code_is_in_sat_list
############################################################
    assign_cost_type
    respond_to do |format|
      if @store.save
        assign_series
        certificate_saving_process
        key_savign_process
        create_warehouse
        create_stores_inventory(@store)
        create_prospect_from_store
        create_supplier_for_store
        create_cash_register
        format.html { redirect_to @store, notice: 'La tienda fue dada de alta exitosamente.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
############################################################
#CAMBIAR ESTA LÓGICA AL TENER UN BUSCADOR CON AJAX
#    zip_code_is_in_sat_list
############################################################
    assign_cost_type
    @prospect = Prospect.find_by_store_code(@store.store_code) || Prospect.find_by_store_prospect_id(@store)
    respond_to do |format|
      if @store.update(store_params)
        certificate_saving_process
        key_savign_process
        update_prospect_from_store
        save_csv_files
        format.html { redirect_to @store, notice: 'La tienda fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to @store, notice: 'La tienda fue eliminada correctamente.' }
      format.json { head :no_content }
    end
  end

  def get_last_series
    @last_series = Store.last.series
  end

  def assign_series
    @store.update(series: @last_series.next)
  end

  def save_csv_files
    @store = current_user.store
    if params[:store][:initial_inventory].present?
      @store.update(
        initial_inventory: params[:store][:initial_inventory]
      )
    end
    if params[:store][:current_inventory].present?
      @store.update(
        current_inventory: params[:store][:current_inventory]
      )
    end
    if params[:store][:prospects_file].present?
      @store.update(
        prospects_file: params[:store][:prospects_file]
      )
    end
    if (params[:store][:initial_inventory].present? || params[:store][:current_inventory].present? || params[:store][:prospects_file].present?)
      process_csv_files
    end
  end

  def process_csv_files

    ### INICIAR LAS PRUEBAS CON ESTE

    @product_counter = 0
    @prospect_create_counter = 0
    @prospect_update_counter = 0
    initial_inventory = params[:store][:initial_inventory]
    current_inventory = params[:store][:current_inventory]
    prospects = params[:store][:prospects_file]

    unless initial_inventory == nil
      url = @store.initial_inventory_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        store = @store
        product = Product.find_by_unique_code(row['cod'])
        if product.nil? || (product.classification != 'de línea' && product.store_id != current_user.store.id)
          unfinded << row['cod']
        else
          store.id == 1 ? inventory = Inventory.where(product: product).first : inventory = store.stores_inventories.where(product: product).first
          entries = store.stores_warehouse_entries.where(product: product)
          quantity = row['cant'].to_i
          if store.store_type.store_type == 'franquicia'
            discount_percent = product.discount_for_franchises / 100
          elsif store.store_type.store_type == 'tienda propia' || store.store_type.store_type == 'corporativo'
            discount_percent = product.discount_for_stores / 100
          end
          cost = product.price * (1 - discount_percent)
          discount = product.price * discount_percent * quantity
          final_price = product.price * (1 - discount_percent)
          entries.each do |entry|
            entry.delete
          end
          if store.id == 1
            movement = Movement.new(
              store: store,
              product: product,
              quantity: quantity.abs,
              cost: cost,
              total_cost: (cost * quantity).round(2),
              supplier: product.supplier,
              discount_applied: discount.round(2),
              automatic_discount: discount.round(2),
              user: current_user
            )
          else
            movement = StoreMovement.new(
              store: store,
              product: product,
              quantity: quantity.abs,
              web: true,
              pos: false,
              cost: cost,
              total_cost: (cost * quantity).round(2),
              supplier: product.supplier,
              discount_applied: discount.round(2),
              automatic_discount: discount.round(2),
              user: current_user
            )
          end

          quantity >= 0 ? movement.movement_type = 'alta' : movement.movement_type = 'baja'

          if movement.save
            @product_counter += 1
          end
          if store.id == 1
            WarehouseEntry.create(
              product: product,
              store: store,
              quantity: quantity,
              movement: movement
            )
            inventory.update(quantity: inventory.quantity.to_i + quantity)
          else
            StoresWarehouseEntry.create(
              product: product,
              store: store,
              quantity: quantity,
              store_movement: movement
            )
            inventory.update(quantity: inventory.quantity.to_i + quantity, rack: row['estante'], level: row['nivel'])
          end
        end
      end
      unfinded.join(", ")
      @product_undefined = unfinded
    end

    unless current_inventory == nil
      url = @store.current_inventory_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        store = @store
        product = Product.find_by_unique_code(row['cod'])
        if product.nil? || (product.classification != 'de línea' && product.store_id != current_user.store.id)
          unfinded << row['cod']
        else
          store.id == 1 ? inventory = Inventory.where(product: product).first : inventory = store.stores_inventories.where(product: product).first
          entries = store.stores_warehouse_entries.where(product: product)
          quantity = row['cant'].to_i
          if store.store_type.store_type == 'franquicia'
            discount_percent = product.discount_for_franchises / 100
          elsif store.store_type.store_type == 'tienda propia' || store.store_type.store_type == 'corporativo'
            discount_percent = product.discount_for_stores / 100
          end
          cost = product.price * (1 - discount_percent)
          discount = product.price * discount_percent * quantity
          final_price = product.price * (1 - discount_percent)
          entries.each do |entry|
            entry.delete
          end
          if store.id == 1
            movement = Movement.new(
              store: store,
              product: product,
              quantity: quantity.abs,
              cost: cost,
              total_cost: (cost * quantity).round(2),
              supplier: product.supplier,
              discount_applied: discount.round(2),
              automatic_discount: discount.round(2),
              user: current_user
            )
          else
            movement = StoreMovement.new(
              store: store,
              product: product,
              quantity: quantity.abs,
              web: true,
              pos: false,
              cost: cost,
              total_cost: (cost * quantity).round(2),
              supplier: product.supplier,
              discount_applied: discount.round(2),
              automatic_discount: discount.round(2),
              user: current_user
            )
          end

          quantity >= 0 ? movement.movement_type = 'alta' : movement.movement_type = 'baja'

          if movement.save
            @product_counter += 1
          end
          if store.id == 1
            WarehouseEntry.create(
              product: product,
              store: store,
              quantity: quantity,
              movement: movement
            )
            inventory.update(quantity: inventory.quantity.to_i + quantity)
          else
            StoresWarehouseEntry.create(
              product: product,
              store: store,
              quantity: quantity,
              store_movement: movement
            )
            inventory.update(quantity: inventory.quantity.to_i + quantity, rack: row['estante'], level: row['nivel'])
          end
        end
      end
      unfinded.join(", ")
      @product_undefined = unfinded
    end

    unless prospects == nil
      url = @store.prospects_file_url
      csv = CSV.parse(open(url).read, headers: true, encoding: 'ISO-8859-1')
      unfinded = []
      csv.each do |row|
        @store = current_user.store
        name = row['nombre_de_empresa_o_cliente']
        phone = row['tel_fijo']
        contact_first_name = row['contacto_primer_nombre']
        contact_last_name = row['contacto_apellido_paterno']
        if (name == '')
          unfinded << name
        else
          if Prospect.find_by_legal_or_business_name(name) == nil
            prospect = Prospect.create(
              legal_or_business_name: name,
              prospect_type: row['giro'],
              contact_first_name: contact_first_name,
              contact_middle_name: row['contacto_segundo_nombre'],
              contact_last_name: contact_last_name,
              second_last_name: row['contacto_apellido_materno'],
              contact_position: row['puesto_del_contacto'],
              direct_phone: phone,
              extension: row['ext'],
              cell_phone: row['cel'],
              store: @store,
              email: row['mail']
            )
            @prospect_create_counter += 1
            if prospect.billing_address == nil
              rfc = row['rfc']
              unless (rfc == nil || rfc.length < 12 || rfc.length > 13)
                BillingAddress.create(
                  business_name: name,
                  rfc: row['rfc'],
                  street: row['calle'],
                  exterior_number: row['num_ext'],
                  interior_number: row['num_int'],
                  zipcode: row['cod_postal'],
                  neighborhood: row['colonia'],
                  city: row['ciudad'],
                  store: @store,
                  state: row['estado'],
                  country: 'México'
                )
              end
            else
              prospect.billing_address.update(
                business_name: name,
                rfc: row['rfc'],
                street: row['calle'],
                exterior_number: row['num_ext'],
                interior_number: row['num_int'],
                zipcode: row['cod_postal'],
                neighborhood: row['colonia'],
                city: row['ciudad'],
                store: @store,
                state: row['estado']
              )
            end
          else
            prospect = Prospect.find_by_legal_or_business_name(name)
            prospect.update(
              legal_or_business_name: name,
              prospect_type: row['giro'],
              contact_first_name: contact_first_name,
              contact_middle_name: row['contacto_segundo_nombre'],
              contact_last_name: contact_last_name,
              second_last_name: row['contacto_apellido_materno'],
              contact_position: row['puesto_del_contacto'],
              direct_phone: phone,
              extension: row['ext'],
              cell_phone: row['cel'],
              store: @store,
              email: row['mail']
            )
            @prospect_update_counter += 1
            if prospect.billing_address == nil
              rfc = row['rfc']
              unless (rfc == nil || rfc.length < 12 || rfc.length > 13)
                BillingAddress.create(
                  business_name: name,
                  rfc: row['rfc'].upcase,
                  street: row['calle'],
                  exterior_number: row['num_ext'],
                  interior_number: row['num_int'],
                  zipcode: row['cod_postal'],
                  neighborhood: row['colonia'],
                  city: row['ciudad'],
                  state: row['estado'],
                  store: @store,
                  country: 'México'
                )
              end
            else
              prospect.billing_address.update(
                business_name: name,
                rfc: row['rfc'].upcase,
                street: row['calle'],
                exterior_number: row['num_ext'],
                interior_number: row['num_int'],
                zipcode: row['cod_postal'],
                neighborhood: row['colonia'],
                city: row['ciudad'],
                store: @store,
                state: row['estado']
              )
            end
          end
        end
      end
      unfinded.join(", ")
      @prospects_results = unfinded
    end
    @product_counter
    @prospect_create_counter
    @prospect_update_counter

    notice_string = ""
    notice_string += "Productos actualizados: #{@product_counter}. " if @product_counter > 0
    notice_string += "Prospectos creados: #{@prospect_create_counter}. " if @prospect_create_counter > 0
    notice_string += "Prospectos actualizados: #{@prospect_update_counter}. " if @prospect_update_counter > 0
    notice_string += "Los siguientes códigos no fueron encontrados: #{@product_undefined}. " if @product_undefined != ''
    notice_string += "Los prospectos no fueron agregados / actualizados por falta de datos: #{@prospects_results}. " if @prospects_results != ''

    redirect_to root_path, notice: "#{notice_string}"
  end

  def all_products_except_special
    suppliers_id = []
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    Product.where(supplier: suppliers_id).where.not(classification: ['especial', 'de tienda'])
  end

  def create_stores_inventory(store)
    all_products_except_special.each do |product|
      StoresInventory.create(product: product, store: store)
    end
  end

############################################################
#CAMBIAR ESTA LÓGICA AL TENER UN BUSCADOR CON AJAX
  def zip_code_is_in_sat_list
    SatZipcode.find_by_zipcode(params[:store][:zip_code]) ? @value = true : @value = false
    if @value == false
      Store.my_validation(@value)
    end
  end
############################################################

  def create_warehouse
    @warehouse = Warehouse.create(
                                  name: "Almacén #{@store.store_name}",
                                  store: @store,
                                  business_unit: @store.business_unit,
                                  business_group: @store.business_group,
                                  warehouse_code: "AT#{@store.store_code}"
                                  )
  end

  def assign_cost_type
    cost_type = CostType.find_by_warehouse_cost_type('PEPS')
    @store.cost_type_selected_since = Date.today
    @store.update(cost_type: cost_type)
  end

  def create_prospect_from_store
    @prospect = Prospect.create(
                                legal_or_business_name: @store.store_name,
                                business_type: @store.type_of_person,
                                prospect_type: 'comercialización de productos',
                                contact_first_name: @store.contact_first_name,
                                contact_middle_name: @store.contact_middle_name,
                                contact_last_name: @store.contact_last_name,
                                second_last_name: @store.second_last_name,
                                direct_phone: @store.direct_phone,
                                extension: @store.extension,
                                cell_phone: @store.cell_phone,
                                email: @store.email,
                                store_code: @store.store_code,
                                store_type: @store.store_type,
                                store_prospect: @store,
                                credit_days: 30,
                                business_unit: BusinessUnit.find(1),
                                business_group: BusinessGroup.find_by_business_group_type('main')
                                )
    assign_delivery_address
    assign_billing_address
    update_discount_rules
  end

  def update_prospect_from_store
    @prospect.update(
                      legal_or_business_name: @store.store_name,
                      business_type: @store.type_of_person,
                      prospect_type: 'comercialización de productos',
                      contact_first_name: @store.contact_first_name,
                      contact_middle_name: @store.contact_middle_name,
                      contact_last_name: @store.contact_last_name,
                      second_last_name: @store.second_last_name,
                      direct_phone: @store.direct_phone,
                      extension: @store.extension,
                      cell_phone: @store.cell_phone,
                      email: @store.email,
                      store_code: @store.store_code,
                      store_type: @store.store_type,
                      store_prospect: @store,
                      business_unit: BusinessUnit.find(1),
                      business_group: BusinessGroup.find_by_business_group_type('main')
                      )
    assign_delivery_address
    assign_billing_address
  end

  def create_cash_register
    CashRegister.create(
                        name: "1",
                        store: @store,
                        balance: 0,
                        cash_number: 1
                        )
  end

  def assign_delivery_address
    delivery = @store.delivery_address
    if @store.delivery_address.present?
      @prospect.update(delivery_address: delivery)
    end
  end

  def assign_billing_address
    billing = @store.business_unit.billing_address
    if @store.business_unit.billing_address.present?
      @prospect.update(billing_address: billing)
    end
  end

  def create_supplier_for_store
    patria_supplier = Supplier.find_by_name('Diseños de Cartón')
    comercializadora_supplier = Supplier.find_by_name('Comercializadora de Cartón y Diseño')
    @store.suppliers << patria_supplier
    @store.suppliers << comercializadora_supplier
    @store.save
  end

private

  def certificate_saving_process
    unless params[:store][:certificate] == nil
      save_certificate_number
      save_certificate_content
      save_pem_certificate
      save_base64_encrypted_cer
    end
  end

  def key_savign_process
    unless params[:store][:key] == nil
      save_pem_key
      save_encrypted_key
      save_base64_encrypted_key
      save_unencrypted_key
    end
  end

  def get_certificate_number
    file = File.join(Rails.root, "public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer")
    serial = `openssl x509 -inform DER -in #{file} -noout -serial`
    n = serial.slice(7..46)
    @certificate_number = ''
    x = 1
    for i in 0..n.length
      if x % 2 == 0
        @certificate_number << n[i]
      end
      x += 1
    end
    @certificate_number
  end

  def save_certificate_number
    get_certificate_number
    @store.update(certificate_number: @certificate_number)
  end

  def save_certificate_content
    unless params[:store][:certificate] == nil
      @cer_file = Rails.root.join('public', 'uploads', 'store', "#{@store.id}", 'certificate', 'cer.cer')
      b64 = Base64.encode64(File::read(@cer_file))
      clean = b64.gsub("\n",'')
      @store.update(certificate_content: clean)
    end
  end

  def save_pem_certificate
    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem"), "w") do |file|
      file.write('')
    end

    cer_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem")
    `openssl x509 -inform DER -outform PEM -in #{@cer_file} -pubkey -out #{cer_pem}`
  end

  def save_base64_encrypted_cer
    file = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.cer.pem"))
    cer_b64 = Base64.encode64(file)

    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cerb64.cer.pem"), "w") do |file|
      file.write(cer_b64)
    end
  end

  def save_der_certificate
    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.der"), "w") do |file|
      file.write('')
    end

    cer_der = Rails.root.join("public", "uploads", "store", "#{@store.id}", "certificate", "cer.der")

    `openssl x509 -outform der -in #{cer_pem} -out #{cer_der}`
  end

  def save_pem_key
    file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.key")
    password = params[:store][:certificate_password]

    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem"), "w") do |file|
      file.write('')
    end

    key_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem")
    `openssl pkcs8 -inform DER -in #{file} -passin pass:#{password} -out #{key_pem}`
  end

  def save_encrypted_key
    file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.pem")
    password = ENV['password_pac']

    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key"), "w") do |file|
      file.write('')
    end

    enc = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key")

    `openssl rsa -in #{file} -des3 -out #{enc} -passout pass:"#{password}"`
  end

  def save_base64_encrypted_key
    file = File.read(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key"))
    key_b64 = Base64.encode64(file)

    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "keyb64.enc.key"), "w") do |file|
      file.write(key_b64)
    end
  end

  def save_unencrypted_key
    file = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "key.enc.key")
    password = ENV['password_pac']

    File.open(Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "new_key.pem"), "w") do |file|
      file.write('')
    end

    new_pem = Rails.root.join("public", "uploads", "store", "#{@store.id}", "key", "new_key.pem")

    `openssl rsa -in #{file} -passin pass:"#{password}" -out #{new_pem}`
  end

  def get_discount_rules
    @b_units = BusinessGroup.find_by_business_group_type('main').business_units
    @corporate_d_rules = DiscountRule.where(business_unit: @b_units)
    @stores_d_rules = DiscountRule.where.not(store: nil)
  end

  def update_discount_rules
    get_discount_rules
    b_g = @b_units.first.business_group
    @corporate_d_rules.each do |rule|
      unless rule.prospect_list.include?(@prospect.id.to_s)
        if rule.prospect_filter == 'todos los clientes'
          rule.prospect_list << @prospect.id.to_s if @prospect.business_group == rule.business_unit.business_group
        elsif rule.prospect_filter == 'clientes finales (no tiendas)'
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_prospect == nil)
        elsif rule.prospect_filter == 'tiendas propias y franquicias'
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_prospect != nil)
        elsif rule.prospect_filter == 'solo tiendas propias'
          type = StoreType.find_by_store_type('tienda propia')
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
        elsif rule.prospect_filter == 'solo franquicias'
          type = StoreType.find_by_store_type('franquicia')
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
        elsif rule.prospect_filter == 'solo distribuidores'
          type = StoreType.find_by_store_type('distribuidor')
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
        elsif rule.prospect_filter == 'solo corporativo'
          type = StoreType.find_by_store_type('corporativo')
          rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
        end
      end
      rule.save
    end
    @stores_d_rules.each do |rule|
      unless rule.prospect_list.include?(@prospect.id.to_s)
        if rule.prospect_filter == 'todos los clientes'
          rule.prospect_list << @prospect.id.to_s if @prospect.store == rule.store
        end
      end
      rule.save
    end
  end

  def set_store
    if current_user.role.name == 'platform-admin'
      @store = Store.find(params[:id])
    else
      @store = current_user.store
    end
  end

  def store_params
    params.require(:store).permit(
                                  :store_type_id,
                                  :store_code,
                                  :store_name,
                                  :store_id,
                                  :business_unit_id,
                                  :business_group_id,
                                  :delivery_address_id,
                                  :billing_address_id,
                                  :cost_type_id,
                                  :cost_type_selected_since,
                                  :months_in_inventory,
                                  :reorder_point,
                                  :critical_point,
                                  :contact_first_name,
                                  :contact_middle_name,
                                  :contact_last_name,
                                  :second_last_name,
                                  :direct_phone,
                                  :extension,
                                  :cell_phone,
                                  :email,
                                  :type_of_person,
                                  :prospect_status,
                                  :zipcode,
                                  :overprice,
                                  :certificate,
                                  :key,
                                  :certificate_password,
                                  :certificate_number,
                                  :certificate_content,
                                  :bill_last_folio,
                                  :credit_note_last_folio,
                                  :debit_note_last_folio,
                                  :return_last_folio,
                                  :pay_bill_last_folio,
                                  :advance_e_last_folio,
                                  :advance_i_last_folio,
                                  :initial_inventory,
                                  :current_inventory,
                                  :prospects_file,
                                  :collection_active,
                                  :days_before,
                                  :days_after
                                  )
  end

  def allow_only_platform_admin_role(role = current_user.role.name)
    if role != 'platform-admin'
      redirect_to root_path
    end
  end

  def allow_store_admin_or_platform_admin_role(role = current_user.role.name)
    unless (role == 'platform-admin' || role == 'store-admin')
      redirect_to root_path
    end
  end

end
