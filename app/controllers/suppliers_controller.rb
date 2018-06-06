class SuppliersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :set_business_group, only: [:new, :save_supplier_to_business_group]
  # GET /suppliers
  # GET /suppliers.json
  def index
    user = current_user.role.name
    current_user.store.suppliers == [] ? @suppliers = [] : @suppliers = current_user.store.suppliers
    Supplier.find([1,2]).each do |supplier|
      @suppliers << supplier unless @suppliers.include?(supplier)
    end
    @suppliers
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)
    save_supplier_to_business_group
    save_supplier_to_business_unit
    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'El proveedor fue dado de alta correctamente.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'El proveedor fue dado modificado correctamente.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'El proveedor fue eliminado correctamente.' }
      format.json { head :no_content }
    end
  end

  def save_supplier_to_business_group
    @business_group = current_user.store.business_unit.business_group
    @business_group.suppliers << @supplier
    @business_group.save
  end

  def save_supplier_to_business_unit
    @business_unit = current_user.store.business_unit
    @business_unit.suppliers << @supplier
    @business_unit.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def set_business_group
      @business_group = BusinessGroup.find(params[:business_group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(
      :name,
      :business_type,
      :type_of_person,
      :contact_first_name,
      :contact_middle_name,
      :contact_last_name,
      :contact_position,
      :direct_phone,
      :extension,
      :cell_phone,
      :email,
      :supplier_status,
      :delivery_address_id,
      :last_purchase_bill_date,
      :last_purhcase_folio,
      :store_id,
      :business_group_id
      )
    end

end
