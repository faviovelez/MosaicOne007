class DeliveryAddressesController < ApplicationController
  # Este controller es para crear o modificar las direcciones de entrega. Cada Order tiene una dirección de entrega y esta puede ser la del prospecto (Prospect) o la de la tienda (Store) o la de una paquetería (Carrier).

  before_action :authenticate_user!
  before_action :set_delivery_address, only: [:show, :edit, :update, :destroy]
  before_action :identify_owner_type, only: [:new, :create, :update]

  def index
  end

  def show
  end

  # Solo debe permitir crear una vez la dirección, si detecta que ya tiene, debe mandar a editar.
  def new
    if @owner.delivery_address.nil?
      @delivery = DeliveryAddress.new
    else
      redirect_to edit_delivery_address_path(@owner.delivery_address)
    end
  end

  def create
    @delivery = DeliveryAddress.new(delivery_params)
    respond_to do |format|
      if @delivery.save
        save_delivery_address_to_owner
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

  # Método para asignar dirección de entrega al owner (Store, Prospect u Order)
  def save_delivery_address_to_owner
    @owner.delivery_address = @delivery
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
