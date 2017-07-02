class RequestsController < ApplicationController
# Este controller solo debe manejar la creación y modificación de requests individuales por la tienda, managers y designers

  before_action :set_request, only: [:show, :edit, :update, :destroy, :follow]
  before_action :new, only: [:catalog, :special]
  before_action :set_today_date, only: [:follow,
    :manager_assigned_requests,
    :manager_unassigned_requests,
    :assigned,
    :unassigned,
    :assigned_to_designer]

  def set_today_date
    @a = Date.today
  end

  def catalog
  end

  def follow
  end

  def special
  end

  def assigned
    manager_assigned_requests
  end

  def unassigned
    manager_unassigned_requests
  end

  def assigned_to_designer
    designer_assigned_requests
  end
  # GET /requests
  # GET /requests.json
  def index
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  def desgin
  end

  # GET /requests/new
  def new
    @prospect = Prospect.find(params[:prospect_id])
    @request = @prospect.requests.build
  end

  # GET /requests/1/edit
  def edit
  end

  def search_design(input = params[:request][:design_like])
    @product = ProductCatalog.find_by_unique_code(input) || ProductCatalog.find_by_former_code(input)
    if input != nil && @product != nil
      @request.design_like = @product.design_type
    elsif input != nil && @product = nil
      @request.design_like = input
    end
  end

  def search_resistance(input = params[:request][:resistance_like])
    @product = ProductCatalog.find_by_unique_code(input) || ProductCatalog.find_by_former_code(input)
    if input != nil && @product != nil
      @request.design_like = @product.design_type
      @request.resistance_like = @product.resistance_main_material
    elsif input != nil && @product = nil
      @request.resistance_like = input
    end
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    search_design
    search_resistance
    save_user_request
    save_store_request
    save_request_status
    save_prospect_to_request
    check_saving_type
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

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'La solicitud de cotización fue eliminada correctamente.' }
      format.json { head :no_content }
    end
  end

# Es probable que borre este método de aquí
  def manager_assigned_requests
    @assigned = Request.where('status' => ['solicitada','cotizando','modificada']).joins(users: :role).where('roles.name' => 'manager')
    @assigned
  end

# Es probable que borre este método de aquí
  def manager_unassigned_requests
    manager_assigned_requests
    @requestes = Request.where('status' => ['solicitada','cotizando','modificada'])
    @unassigned = @requestes - @assigned
  end

# Es probable que borre este método de aquí
  def designer_assigned_requests
    @assigned_to_designer = Request.where('status' => ['solicitada','cotizando','modificada']).joins(users: :role).where('roles.name' => 'designer')
  end

  def check_saving_type
    if params[:enviar]
      @request.status = 'solicitada'
    elsif params[:guardar]
      @request.status = 'creada'
    end
  end

  def save_user_request
    @user = current_user
    @request.users << @user
  end

  def save_request_status
    @request.status = 'solicitada'
  end

  def save_prospect_to_request
    @prospect = Prospect.find(params[:prospect_id])
    @request.prospect = @prospect
  end

  def save_store_request
    @store = @user.store
    @request.store = @store
    @request.store_code = @store.store_code
    @request.store_name = @store.store_name
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:product_type,
       :product_what,
       :product_length,
       :product_width,
       :product_height,
       :product_weight,
       :for_what,
       :boxes_stow,
       :quantity,
       :inner_length,
       :inner_width,
       :inner_height,
       :outer_length,
       :outer_widht,
       :outer_height,
       :bag_length,
       :bag_width,
       :bag_height,
       :main_material,
       :resistance_main_material,
       :secondary_material,
       :resistance_secondary_material,
       :third_material,
       :resistance_third_material,
       :impression,
       :inks,
       :impression_finishing,
       :delivery_date,
       :maximum_sales_price,
       :observations,
       :notes,
       :prospect_id,
       :final_quantity,
       :require_dummy,
       :require_printcard,
       :printcard_authorised,
       :dummy_generated,
       :dummy_authorised,
       :printcard_generated,
       :payment_uploaded,
       :authorisation_signed,
       :date_finished,
       :internal_cost,
       :internal_price,
       :sales_price,
       :impression_type,
       :impression_where,
       :dummy_cost,
       :design_cost,
       :design_like,
       :resistance_like,
       :rigid_color,
       :paper_type_rigid,
       :exterior_material_color,
       :interior_material_color,
       :manager,
       :store_code,
       :store_name,
       :user_id,
       :status,
       :require_design,
       :name_type,
       :exhibitor_height,
       :tray_quantity,
       :tray_length,
       :tray_width,
       :contraencolado,
       :how_many)
    end

end
