class StoresController < ApplicationController
  # En este se crean nuevas tiendas (solo el usuario de product-admin deberá poder crearlas y un user 'store' solo podrá modificarlas (algunas modificaciones estarán restringidas)
  before_action :authenticate_user!
  before_action :set_store, only: [:show, :new, :create, :update]
  before_action :require_permission, only: :new

  def index
  end

  def show
  end

  def edit
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'La tienda fue dada de alta exitosamente.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @delivery.update(prospect_params)
        format.html { redirect_to @store, notice: 'La tienda fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to @store, notice: 'La tienda fue eliminada correctamente' }
      format.json { head :no_content }
    end
  end


private

  def set_store
    @store = current_user.store
  end

  def store_params
    params.require(:store).permit(:store_type, :store_code, :store_name, :group, :discount, :business_unit, :delivery_address, :billing_address)
  end

  def require_permission(role = current_user.role.name)
    if role != 'platform-admin'
      redirect_to root_path
    end
  end

end
