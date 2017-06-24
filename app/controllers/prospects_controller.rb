class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]

  # GET /prospects
  # GET /prospects.json
  def index
  end

  def set_data_from_prospects
    @prospects = Prospect.all
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

  def prospect
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
    end

    def save_store_prospect
      @user = current_user
      @store = @user.store
      @prospect.store = @store
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(:store_id, :prospect_type, :contact_first_name, :second_last_name, :contact_middle_name, :contact_last_name, :contact_position, :direct_phone, :extension, :cell_phone, :business_type, :prospect_status, :discount, :legal_or_business_name, :billing_address_id, :delivery_address_id)
    end
end
