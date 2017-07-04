class RequestsController < ApplicationController
# Este controller solo debe manejar la creación y modificación de requests individuales por la tienda, managers y designers
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @prospect = Prospect.find(params[:prospect_id])
    @requests = @prospect.requests
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  def special
  end

  # GET /requests/new
  def new
    @prospect = Prospect.find(params[:prospect_id])
    @request = @prospect.requests.build
  end

  # GET /requests/1/edit
  def edit
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
        format.html { redirect_to @request, notice: 'La solicitud de cotización fue generada exitosamente.' }
        format.json { render :show, status: :created, location: @request }
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
    assign_to_current_user
    assign_design_request
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'La solicitud de cotización fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    find_user_in_request(user = current_user)
    if user_find
      @request.destroy
      respond_to do |format|
        format.html { redirect_to requests_url, notice: 'La solicitud de cotización fue eliminada correctamente.' }
        format.json { head :no_content }
      end
    end
  end

  def days_since
    a = Date.today
    date = @request.created_at.to_date
    @days_since = (a - date).to_i
  end

  def find_user_in_request(user = current_user)
    user_find = false
    @request.users.each do |user_in_request|
      if (user_in_request.id == user.id)
        user_find = true
      end
    end
    user_find
  end

  def search_design(input = params[:request][:design_like])
    define_search_field
    if input != nil && @product != nil
      @request.design_like = @product.design_type
    elsif input != nil && @product = nil
      @request.design_like = input
    end
  end

  def search_resistance(input = params[:request][:resistance_like])
    define_search_field
    if input != nil && @product != nil
      @request.design_like = @product.design_type
      @request.resistance_like = @product.resistance_main_material
    elsif input != nil && @product = nil
      @request.resistance_like = input
    end
  end

  def define_search_field(input = params[:request][:resistance_like])
    if Product.find_by_unique_code(input) != nil
      @product = Product.find_by_unique_code(input)
    elsif Product.find_by_former_code(input) != nil
      @product = Product.find_by_former_code(input)
    end
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

# Método para managers o designers: asigna la solicitud si no hay otro usuario con el mismo rol en la solicitud
  def assign_to_current_user(user = current_user, role = current_user.role.name)
    users = User.joins(:role).where('roles.name' => (role))
    users_counter = 0
    @request.users.each do |user|
      users.each do |other_user|
        if (user.id == other_user.id)
          user_counter+=1
        end
      end
    end
    if params[:asignar] && user_counter < 1
      @request.users << user
    else
      format.html { redirect_to "#", notice: 'No se puede asignar esta solicitud, ya fue asignada a otro(a) #{role}' }
    end
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
