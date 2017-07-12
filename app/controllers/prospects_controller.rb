class ProspectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_store, only: [:new, :create, :update]

  # GET /prospects
  # GET /prospects.json
  def index
    store_prospects
  end

  # GET /prospects/1
  # GET /prospects/1.json
  def show
  end

  # GET /prospects/new
  def new
    @prospect = Prospect.new
  end

  # GET /prospects/1/edit
  def edit
  end

  # POST /prospects
  # POST /prospects.json
  def create
    @prospect = Prospect.new(prospect_params)
    save_store_prospect
    respond_to do |format|
      if @prospect.save
        format.html { redirect_to @prospect, notice: 'El prospecto fue dado de alta exitosamente.' }
        format.json { render :show, status: :created, location: @prospect }
      else
        format.html { render :new }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prospects/1
  # PATCH/PUT /prospects/1.json
  def update
    save_prospect_to_store
    respond_to do |format|
      if @prospect.update(prospect_params)
        format.html { redirect_to @prospect, notice: 'El prospecto fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @prospect }
      else
        format.html { render :edit }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @prospect.destroy
    respond_to do |format|
      format.html { redirect_to prospects_url, notice: 'El prospecto fue eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  def save_prospect_to_store
    @store.prospect = @prospect
    @store.save
  end

  def store_prospects
    @store = current_user.store
    @prospects = @store.prospects
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
    end

    def save_store_prospect
      @user = current_user
      @prospect.store = @store
    end

    def set_store
      @store = Store.find(params[:store_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(:store_id, :prospect_type, :contact_first_name, :second_last_name, :contact_middle_name, :contact_last_name, :contact_position, :direct_phone, :extension, :cell_phone, :business_type, :prospect_status, :discount, :legal_or_business_name, :billing_address_id, :delivery_address_id)
    end
end
