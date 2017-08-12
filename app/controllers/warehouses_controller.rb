class WarehousesController < ApplicationController
  # Este controller es para crear o modificar almacenes.
  before_action :authenticate_user!
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  # Warehouse (almacén) debe pertenecer a un owner (que puede ser una tienda o a una Business Unit

  def index
    @warehouses = current_user.store.business_unit.business_group.warehouses
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
      if @warehouse.update(warehouse_params)
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

private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
      params.require(:warehouse).permit(:name, :delivery_address_id, :business_unit_id, :business_group_id, :warehouse_code, :store_id)
  end

end
