class DeliveryAddressesController < ApplicationController
  before_action :set_delivery_address, only: [:show, :edit, :update, :destroy]
  before_action :identify_owner_type, only: [:new, :create, :update]

  def index
  end

  def show
  end

  def new
    if @owner.delivery_address.nil?
      @delivery = DeliveryAddress.new
    else
      redirect_to edit_delivery_address_path(@owner.delivery_address)
    end
  end

  def create
    @delivery = DeliveryAddress.new(delivery_params)
    save_delivery_address_to_owner
    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'La dirección de entrega fue dada de alta exitosamente.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    save_delivery_address_to_owner
    respond_to do |format|
      if @delivery.update(prospect_params)
        format.html { redirect_to @delivery, notice: 'La dirección de entrega fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to @owner, notice: 'La dirección de entrega fue eliminada correctamente' }
      format.json { head :no_content }
    end
  end

  def save_delivery_address_to_owner
    @owner.billing_address = @delivery
    @owner.save
  end

private

  def set_delivery_address
    @delivery = DeliveryAddress.find(params[:id])
  end

  def identify_owner_type
    if params[:store_id]
      @owner = Store.find(params[:store_id])
    elsif params[:prospect_id]
      @owner = Prospect.find(params[:prospect_id])
    elsif params[:order_id]
      @owner = Order.find(params[:order_id])
    end
  end


  def delivery_params
    params.require(:delivery_address).permit(:street, :exterior_number, :interior_number, :zipcode, :neighborhood, :city, :state, :country, :additional_references, :type_of_address)
  end

end
