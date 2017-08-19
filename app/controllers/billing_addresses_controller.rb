class BillingAddressesController < ApplicationController
  # Este controller es para crear o modificar los datos de facturación.
  before_action :authenticate_user!
  before_action :set_billing_address, only: [:show, :edit, :update, :destroy]

  # Billing address (datos de facturación) debe pertenecer a un owner (que puede ser una tienda o a un prospecto o una orden, pero cada orden debe tener ligada una BIlling Address. Para store siempre será la misma (cuando facture Diseños de Cartón) y puede registrarse desde que se da de alta al cliente o después, ya que el estatus de pedido está en 'autorizada'.
  before_action :identify_owner_type, only: [:new, :create]

  def index
  end

  def show
  end

  def edit
  end

  def new
    if @owner.billing_address.nil?
      @billing = BillingAddress.new
    else
      redirect_to edit_billing_address_path(@owner.billing_address)
    end
  end

  def create
    @billing = BillingAddress.new(billing_params)
    respond_to do |format|
      if @billing.save
        save_billing_address_to_owner
        format.html { redirect_to @billing, notice: 'Los datos de facturación fueron dados de alta exitosamente.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @billing.update(billing_params)
        format.html { redirect_to @billing, notice: 'Los datos de facturación fueron modificados exitosamente.' }
        format.json { render :show, status: :ok, location: @billing }
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

  # Este método liga la dirección al owner (Store, Prospect u Order)
  def save_billing_address_to_owner
    @owner.billing_address = @billing
    if @owner.is_a?(Store)
      current_user.store.billing_address = @billing
      current_user.store.business_unit.billing_address = @billing
    elsif @owner.is_a?(BusinessUnit)
      store = current_user.store
      store.update(billing_address: @owner.billing_address)
      store.save
      prospect = Prospect.find_by_store_code(store.store_code)
      prospect.update(billing_address: @owner.billing_address)
      prospect.save
      current_user.store.business_unit.billing_address = @billing
    end
    @owner.save
  end

private

  def set_billing_address
    @billing = BillingAddress.find(params[:id])
  end

  # Este método identifica desde qué owner se agrega la dirección, ya están creados los recursos anidados en routes (Store, Prospect u Order)
    def identify_owner_type
    if params[:store_id]
      @owner = Store.find(params[:store_id])
    elsif params[:prospect_id]
      @owner = Prospect.find(params[:prospect_id])
    elsif params[:order_id]
      @owner = Order.find(params[:order_id])
    elsif params[:business_unit_id]
      @owner = BusinessUnit.find(params[:business_unit_id])
    end
  end

  def billing_params
    params.require(:billing_address).permit(:type_of_person, :business_name, :rfc, :street, :exterior_number, :interior_number, :zipcode, :neighborhood, :city, :state, :country, :prospect_id, :store_id)
  end

end
