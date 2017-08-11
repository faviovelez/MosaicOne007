class WarehousesController < ApplicationController
  # Este controller es para crear o modificar almacenes.
  before_action :authenticate_user!
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  # Warehouse (almacén) debe pertenecer a un owner (que puede ser una tienda o a una Business Unit
  before_action :identify_owner_type, only: [:new, :create]

  def index
    @warehouses = current_user.store.business_unit.warehouses
  end

  def show
  end

  def edit
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)
    save_warehouse_to_owner
    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: 'El almacén fue creado correctamente.' }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @biling.update(warehouse_params)
        format.html { redirect_to @warehouse, notice: 'El almacén fue modificado correctamente.' }
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @warehouse.destroy
    respond_to do |format|
      format.html { redirect_to @owner, notice: 'El almacén fue eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  # Este método liga el almacén (warehouse) al owner (Store ó BusinessUnit)
  def save_warehouse_to_owner
    @owner.warehouse = @warehouse
    @owner.save
  end

private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  # Este método identifica desde qué owner se agrega la dirección, ya están creados los recursos anidados en routes (Store, Prospect u Order)
    def identify_owner_type
    if params[:store_id]
      @owner = Store.find(params[:store_id])
    elsif params[:business_unit]
      @owner = BusinessUnit.find(params[:business_unit_id])
    end
  end

  def warehouse_params
      params.require(:warehouse).permit(:name, :delivery_address_id, :business_unit_id, :warehouse_code, :store_id)
  end

end
