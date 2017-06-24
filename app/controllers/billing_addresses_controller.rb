class BillingAddressesController < ApplicationController
  def index
  end

  def show
  end

  def new
    @prospect = Prospect.find(params[:prospect_id])
    @billing = BillingAddress.new
  end

  def create
    @prospect = Prospect.find(params[:prospect_id])
    @billing = @prospect.billing_address || BillingAddress.new(billing_params)
    respond_to do |format|
      if @billing.save
        @prospect.billing_address = @billing
        @prospect.save
        format.html { redirect_to @prospect, notice: 'Los datos de facturación fueron dados de alta exitosamente.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @biling.update(billing_params)
        format.html { redirect_to @prospect, notice: 'Los datos de facturación fueron modificados exitosamente.' }
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
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to @prospect, notice: 'Los datos de facturación fueron eliminados correctamente' }
      format.json { head :no_content }
    end
  end

private

def billing_params
  params.require(:billing_address).permit(:type_of_person, :business_name, :rfc, :street, :exterior_number, :interior_number, :zipcode, :neighborhood, :city, :state, :country)
end

end
