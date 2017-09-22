class StoresController < ApplicationController
  # En este se crean nuevas tiendas (solo el usuario de product-admin deberá poder crearlas y un user 'store' solo podrá modificarlas (algunas modificaciones estarán restringidas)
  before_action :authenticate_user!
  before_action :set_store, only: [:show, :edit, :update, :show_settings, :inventory_settings]
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

  def inventory_settings
  end

  def show_settings
  end

  def create
    @store = Store.new(store_params)
    assign_cost_type
    respond_to do |format|
      if @store.save
        create_warehouse
        create_prospect_from_store
        format.html { redirect_to @store, notice: 'La tienda fue dada de alta exitosamente.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    unless @store.id == 1
      @prospect = Prospect.find_by_store_code(@store.store_code)
    end
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

  def create_warehouse
    @warehouse = Warehouse.create(
                                  name: "almacén #{@store.store_name}",
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
                                  business_unit: BusinessUnit.find(1),
                                  business_group: BusinessGroup.find_by_business_group_type('main')
                                  )
  end

  def update_prospect_from_store
    if @store.id != 1
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
                        business_unit: BusinessUnit.find(1),
                        business_group: BusinessGroup.find_by_business_group_type('main')
                        )
    end
  end

private

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
                                  :business_unit_id,
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
                                  :business_group_id,
                                  :zipcode
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
