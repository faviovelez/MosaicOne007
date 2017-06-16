class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :new, only: [:catalog, :special]
  before_action :set_data_from_requests, :set_today_date, only: [:follow]

  def set_today_date
    @a = Date.today
  end

  def catalog
  end

  def follow
  end

  def special
  end

  # GET /requests
  # GET /requests.json
  def index
  end

  def set_data_from_requests
    @requests = Request.all
  end
  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    upload_authorisation_payment
    upload_authorisation_document
    save_user_request
    save_store_request
    respond_to do |format|
      if @request.save
        format.html { redirect_to requests_index_path, notice: 'La solicitud de cotización fue generada exitosamente.' }
        format.json { render :index, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    upload_authorisation_payment
    upload_authorisation_document

    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to requests_index_path, notice: 'La solicitud de cotización fue modificada exitosamente.' }
        format.json { render :index, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'La solicitud de cotización fue eliminada correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    def upload_authorisation_payment
      if params[:request][:payment_uploaded].nil?
        @request.payment_uploaded = false
      else
        @request.documents << Document.create(document: params[:request][:payment_uploaded], document_type: 'pago', request: @request)
        @request.payment_uploaded = true
      end
    end

    def save_user_request
      @user = current_user
      @request.user = @user
    end

    def save_store_request
      @store = @user.store
      @request.store = @store
      @request.store_code = @store.store_code
      @request.store_name = @store.store_name
    end

    def upload_authorisation_document
      if params[:request][:authorisation_signed].nil?
        @request.authorisation_signed = false
      else
        @request.documents << Document.create(document: params[:request][:authorisation_signed], document_type: 'pedido', request: @request)
        @request.authorisation_signed = true
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:product_type, :product_what, :product_length, :product_width, :product_height, :product_weight, :for_what, :boxes_stow, :quantity, :inner_length, :inner_width, :inner_height, :outer_length, :outer_widht, :outer_height, :bag_length, :bag_width, :bag_height, :sheet_length, :sheet_height, :main_material, :resistance_main_material, :secondary_material, :resistance_secondary_material, :third_material, :resistance_third_material, :impression, :inks, :impression_finishing, :which_finishing, :delivery_date, :maximum_sales_price, :observations, :notes, :prospect_id, :product_code, :final_quantity, :require_dummy, :require_printcard, :printcard_authorised, :dummy_generated, :dummy_authorised,:printcard_generated, :payment_uploaded, :authorisation_signed, :date_finished, :internal_cost, :internal_price, :sales_price, :impression_type, :impression_where, :dummy_cost, :design_cost, :design_like, :resistance_like, :rigid_color, :paper_type_rigid, :exterior_material_color, :interior_material_color, :other_material_color, :manager, :store_code, :store_name, :user_id)
    end
end
