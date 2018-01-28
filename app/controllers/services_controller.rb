class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    save_sat_key
    save_sat_unit_key
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'El servicio fue creado.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    save_sat_key
    save_sat_unit_key
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'La servicen fue actualizada.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    redirect_to :back, notice: 'El servicio fue eliminado correctamente.'
  end

  def save_sat_key
    if params[:service][:sat_key_id] == ['']
      @service.sat_key = nil
    else
      @service.sat_key = SatKey.find(params[:service][:sat_key_id].second)
    end
  end

  def save_sat_unit_key
    if params[:service][:sat_unit_key_id] == ['']
      @service.sat_unit_key = nil
    else
      @service.sat_unit_key = SatUnitKey.find(params[:service][:sat_unit_key_id].second)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    def service_params
      params.require(:service).permit(
      :unique_code,
      :description,
      :description,
      :price,
      :sat_key_id,
      :unit,
      :sat_unit_key_id,
      :shared,
      :store_id,
      :business_unit_id,
      :created_at,
      :updated_at,
      :delivery_company,
      :current,
      :pos_id,
      :web_id
      )
    end


end
