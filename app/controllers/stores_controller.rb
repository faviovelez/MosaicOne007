class StoresController < ApplicationController
  # En este se crean nuevas tiendas (solo el usuario de product-admin deberá poder crearlas y un user 'store' solo podrá modificarlas (algunas modificaciones estarán restringidas)
  before_action :authenticate_user!
  before_action :set_store, only: [:show, :edit, :update, :show_settings, :settings]
  before_action :allow_only_platform_admin_role, only: :new
  before_action :allow_store_admin_or_platform_admin_role, only: :edit

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

  def create
    @store = Store.new(store_params)
############################################################
#CAMBIAR ESTA LÓGICA AL TENER UN BUSCADOR CON AJAX
    zip_code_is_in_sat_list
############################################################
    assign_cost_type
    respond_to do |format|
      if @store.save
        create_warehouse
        create_store_inventories
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
    zip_code_is_in_sat_list
############################################################
    assign_cost_type
      @prospect = Prospect.find_by_store_code(@store.store_code) || Prospect.find_by_store_prospect_id(@store)
    respond_to do |format|
      if @store.update(store_params)
        update_prospect_from_store
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

  def create_store_inventories
    all_products_except_special
    @products.each do |product|
      StoresInventory.create(product: @product, store: @store)
    end
  end

  def all_products_except_special
    suppliers_id = []
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    @products = Product.where(supplier: suppliers_id).where.not(classification: ['especial', 'de tienda'])
    @products
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

  def get_discount_rules
    @b_units = BusinessGroup.find_by_business_group_type('main').business_units
    @corporate_d_rules = DiscountRule.where(business_unit: @b_units)
    @stores_d_rules = DiscountRule.where.not(store: nil)
    debugger
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
                                  :overprice
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
