class BillingAddressesController < ApplicationController
  before_action :set_billing_address, only: [:show, :edit, :update, :destroy]
  before_action :set_owner, only: [:new, :create, :update]

  def index
  end

  def show
  end

  def new
    if @owner.billing_address.nil?
      @billing = BillingAddress.new
    else
      redirect_to edit
    end
  end

  def create
    @billing = BillingAddress.new(billing_params)
    identify_owner_type
    respond_to do |format|
      if @billing.save
        format.html { redirect_to @billing, notice: 'Los datos de facturación fueron dados de alta exitosamente.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    identify_owner_type
    respond_to do |format|
      if @biling.update(billing_params)
        format.html { redirect_to @billing, notice: 'Los datos de facturación fueron modificados exitosamente.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to @owner, notice: 'Los datos de facturación fueron eliminados correctamente' }
      format.json { head :no_content }
    end
  end

  def identify_owner_type
    if @owner.is_a?(Prospect)
      @owner.billing_address = @billing
    elsif @owner.is_a?(Store)
      @owner.billing_address = @billing
    end
    @owner.save
  end

private

  def set_billing_address
    @billing = BillingAddress.find(params[:id])
  end

  def set_owner
    if params[:store_id]
      @owner = Store.find(params[:store_id])
    elsif params[:prospect_id]
      @owner = Prospect.find(params[:prospect_id])
    end
  end

  def billing_params
    params.require(:billing_address).permit(:type_of_person, :business_name, :rfc, :street, :exterior_number, :interior_number, :zipcode, :neighborhood, :city, :state, :country, :prospect_id, :store_id)
  end

end
