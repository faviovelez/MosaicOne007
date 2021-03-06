class BusinessUnitsController < ApplicationController
  # Este controller es para crear o modificar UNidades de negocio.
  before_action :authenticate_user!
  before_action :set_business_unit, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.role.name == 'platform-admin'
      @business_units = BusinessUnit.all
    else
      @business_units = current_user.store.business_unit.business_group.business_units
    end
  end

  def show
  end

  def edit
  end

  def new
    @business_unit = BusinessUnit.new
  end

  def create
    @business_unit = BusinessUnit.new(business_unit_params)
    respond_to do |format|
      if @business_unit.save
        create_supplier_for_business_unit
        format.html { redirect_to @business_unit, notice: 'La empresa fue creada correctamente.' }
        format.json { render :show, status: :created, location: @business_unit }
      else
        format.html { render :new }
        format.json { render json: @business_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @business_unit.update(business_unit_params)
        format.html { redirect_to @business_unit, notice: 'La empresa fue modificada correctamente.' }
        format.json { render :show, status: :ok, location: @business_unit }
      else
        format.html { render :edit }
        format.json { render json: @business_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @business_unit.destroy
    respond_to do |format|
      format.html { redirect_to @owner, notice: 'La empresa fue eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  def create_supplier_for_business_unit
    patria_supplier = Supplier.find_by_name('Diseños de Cartón')
    comercializadora_supplier = Supplier.find_by_name('Comercializadora de Cartón y Diseño')
    @business_unit.suppliers << patria_supplier
    @business_unit.suppliers << comercializadora_supplier
    @business_unit.save
  end

private

  def set_business_unit
    @business_unit = BusinessUnit.find(params[:id])
  end

  def business_unit_params
      params.require(:business_unit).permit(:name, :billing_address_id, :business_group_id)
  end

end
