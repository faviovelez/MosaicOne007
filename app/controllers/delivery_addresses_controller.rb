class DeliveryAddressesController < ApplicationController

  def index
  end

  def show
  end

  def new
    @prospect = Prospect.find(params[:prospect_id])
    @delivery = DeliveryAddress.new
  end

  def create
    @prospect = Prospect.find(params[:prospect_id])
    @delivery = @prospect.delivery_address || DeliveryAddress.new(delivery_params)
    respond_to do |format|
      if @delivery.save
        @prospect.delivery_address = @delivery
        @prospect.save
        format.html { redirect_to @prospect, notice: 'La dirección de entrega fue dada de alta exitosamente.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @delivery.update(prospect_params)
        format.html { redirect_to @prospect, notice: 'La dirección de entrega fue modificado exitosamente.' }
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
      format.html { redirect_to @prospect, notice: 'La dirección de entrega fue eliminada correctamente' }
      format.json { head :no_content }
    end
  end


private

  def delivery_params
    params.require(:delivery_address).permit(:street, :exterior_number, :interior_number, :zipcode, :neighborhood, :city, :state, :country, :additional_references, :type_of_address)
  end

end
