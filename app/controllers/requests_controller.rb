class RequestsController < ApplicationController
# Este controller solo debe manejar la creación y modificación de requests individuales por la tienda, managers y designers
  before_action :authenticate_user!
  before_action :set_request, only: [:show, :edit, :update, :destroy, :check_assigned, :manager, :manager_view, :confirm, :confirm_view, :price]
  before_action :get_documents, only: [:edit, :show, :confirm, :confirm_view, :manager, :manager_view]
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

  def manager
    check_assigned
  end

  def manager_view
  end

  def confirm
    check_authorisation
  end

  def confirm_view
  end

  def price
    check_price
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
    if params[:request][:how_many] == ''
      @request.how_many = nil
    end
    upload_specification
    request_has_design?
    assign_to_current_user
    save_store_request
    save_prospect_to_request
    save_status
    save_document_identifier_field
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
    if current_user.role.name == 'store'
      request_has_design?
      upload_specification
      @request.update(request_params)
      save_document
      validate_authorisation
      save_status
      save_document_identifier_field
      if @request.update(request_params) && params[:cancelar]
        redirect_to filtered_requests_inactive_view_path, notice: 'La solicitud de cotización fue cancelada.'
      elsif @request.update(request_params)
        redirect_to request_path(@request), notice: 'La solicitud de cotización fue modificada exitosamente.'
      else
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    elsif current_user.role.name == 'manager'
      save_status
      if @request.update(request_params) && params[:asignar]
        assign_to_manager
        redirect_to manager_view_requests_path(@request), notice: "La solicitud fue asignada a #{current_user.first_name} #{current_user.last_name}"
      elsif @request.update(request_params)
        redirect_to manager_view_requests_path(@request), notice: "Los campos fueron actualizados correctamente."
      else
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
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
    else
      rediret_to root_path, notice: 'Solo el usuario que creó esta solicitud o el administrador de tienda pueden borrar esta solicitud'
    end
  end

  def check_price
    if @request.status != 'costo asignado'
      redirect_to requests_path(@request)
    end
  end

  def check_assigned
    redirect_to manager_view_requests_path(@request) if @request.status == 'cotizando'
  end

  def get_documents
    @payment = @request.documents.where(document_type: 'pago')
    @authorisation = @request.documents.where(document_type: 'pedido')
    @specifications = @request.documents.where(document_type: 'especificación')
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

  def define_search_field(input = params[:request][:resistance_like])
    if Product.find_by_unique_code(input) != nil
      @product = Product.find_by_unique_code(input)
    elsif Product.find_by_former_code(input) != nil
      @product = Product.find_by_former_code(input)
    end
  end

  def request_has_design?
    if params[:request][:design_like]
      search_design
    end
    if params[:request][:resistance_like]
      search_resistance
    end
  end

  def search_design(input = params[:request][:design_like])
    define_search_field
    if (input != nil) && (@product != nil)
      @request.design_like = @product.design_type
    elsif (input != nil) && (@product = nil)
      @request.design_like = input
    end
  end

  def search_resistance(input = params[:request][:resistance_like])
    define_search_field
    if (input != nil) && (@product != nil)
      @request.design_like = @product.design_type
      @request.resistance_like = @product.resistance_main_material
    elsif (input != nil) && (@product = nil)
      @request.resistance_like = input
    end
  end

  def save_prospect_to_request
    @prospect = Prospect.find(params[:prospect_id])
    @request.prospect = @prospect
  end

  def save_store_request(store = current_user.store)
    @request.store = store
  end

# Método para managers o designers: asigna la solicitud si no hay otro usuario con el mismo rol en la solicitud
  def assign_to_current_user(user = current_user, role = current_user.role.name)
    users = User.joins(:role).where('roles.name' => (role))
    user_find = false
    @request.users.each do |user|
      users.each do |other_user|
        if (user.id == other_user.id)
          user_find = true
        end
      end
    end
    if user_find == false
      @request.users << user
    end
  end

  def assign_to_manager
    if params[:asignar]
      assign_to_current_user
    end
  end

  def save_document
    search_document_in_request
    if @find_payment == false
      if params[:request][:payment_uploaded] != nil
        payment = Document.create(document: params[:request][:payment_uploaded], document_type: 'pago', request: @request)
        @request.documents << payment
      end
    end
    if @find_authorisation == false
      if params[:request][:authorisation_signed] != nil
        authorisation = Document.create(document: params[:request][:authorisation_signed], document_type: 'pedido', request: @request)
        @request.documents << authorisation
      end
    end
  end

  def save_document_identifier_field
    search_document_in_request
    if @find_payment == true
      @request.update(payment_uploaded: true)
    end
    if @find_authorisation == true
      @request.update(authorisation_signed: true)
    end
    if @find_specification == true
      @request.update(specification_document: true)
    end
  end

  def search_document_in_request
    @find_payment = false
    @find_authorisation = false
    @find_specification = false
    @request.documents.each do |document|
      if (document.document_type == 'pago')
        @find_payment = true
      end
      if (document.document_type == 'pedido')
        @find_authorisation = true
      end
      if (document.document_type == 'especificación')
        @find_specification = true
      end
    end
  end

  def validate_authorisation
    if params[:request][:authorised_without_pay] == '1'
      @request.authorised_without_pay = true
    end
    if params[:request][:authorised_without_doc] == '1'
      @request.authorised_without_doc = true
    end
  end

  def check_document_authorisation
    @doc_ok = false
    if( @request.authorised_without_doc == true) || (@request.authorisation_signed == true)
      @doc_ok = true
    end
    @doc_ok
  end

  def check_payment_authorisation
    @pay_ok = false
    if (@request.payment_uploaded == true) || (@request.authorised_without_pay == true)
      @pay_ok = true
    end
    @pay_ok
  end

  def save_status
    check_document_authorisation
    check_payment_authorisation
    if params[:enviar] || params[:reactivar]
      @request.status = 'solicitada'
    elsif params[:guardar]
      @request.status = 'creada'
    elsif (@doc_ok == true && @pay_ok == true)
      @request.status = 'autorizada'
    elsif params[:cancelar]
      @request.status = 'cancelada'
    elsif params[:asignar]
      @request.status = 'cotizando'
    elsif params[:enviar_dudas]
      @request.status = 'devuelta'
    elsif params[:request][:internal_price]
      @request.status = 'costo asignado'
    elsif params[:request][:sales_price]
      @request.status = 'precio asignado'
    end
  end

  def check_authorisation
    check_document_authorisation
    check_payment_authorisation
    if @request.status == 'autorizada'
      redirect_to request_path(@request), notice: 'Esta solicitud ya fue autorizada.'
    elsif ((@request.status != 'autorizada') && (@pay_ok || @doc_ok))
      redirect_to confirm_view_requests_path(@request)
    end
  end

  def upload_specification
    if params[:request][:specification].present?
      params[:request][:specification].each do |file|
        @request.documents << Document.create(document: file, document_type: 'especificación', request: @request)
      end
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
       :payment_uploaded,
       :authorisation_signed,
       :date_finished,
       :internal_cost,
       :internal_price,
       :sales_price,
       :impression_type,
       :impression_where,
       :design_like,
       :resistance_like,
       :rigid_color,
       :paper_type_rigid,
       :exterior_material_color,
       :interior_material_color,
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
       :tray_divisions,
       :contraencolado,
       :how_many,
       :authorised_without_pay,
       :authorised_without_doc,
       :specification,
       :what_measures,
       :specification_document)
    end
end
