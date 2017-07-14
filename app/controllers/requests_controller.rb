class RequestsController < ApplicationController
# Este controller solo debe manejar la creación y modificación de requests individuales por la tienda, managers y designers
  before_action :authenticate_user!
  before_action :set_request, only: [:show, :edit, :update, :destroy, :check_assigned, :manager, :manager_view, :confirm, :confirm_view, :price, :delete_authorisation_or_payment, :sensitive_fields_changed_after_price_set]
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
    save_document
    request_has_design?
    assign_to_current_user
    save_store_request
    save_prospect_to_request
    save_status
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
      @request.update(request_params)
      delete_authorisation_or_payment
      save_document
      validate_authorisation
      set_authorisation_flag
      save_status
      if @request.update(request_params) && params[:cancelar]
        @request.update(status: 'cancelada')
        redirect_to filtered_requests_inactive_view_path, notice: 'La solicitud de cotización fue cancelada.'
      elsif @request.update(request_params)
        save_status
        @request.save
        redirect_to request_path(@request), notice: 'La solicitud de cotización fue modificada exitosamente.'
      else
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    elsif current_user.role.name == 'manager'
      save_status
      @request.save
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
    if params[:request][:payment] != nil
      payment = Document.create(document: params[:request][:payment_uploaded], document_type: 'pago', request: @request)
      @request.documents << payment
      @request.update(payment_uploaded: true)
      @request.save
    end
    if params[:request][:authorisation] != nil
      authorisation = Document.create(document: params[:request][:authorisation_signed], document_type: 'pedido', request: @request)
      @request.documents << authorisation
      @request.update(authorisation_signed: true)
      @request.save
    end
    if params[:request][:specification].present?
      params[:request][:specification].each do |file|
        @request.documents << Document.create(document: file, document_type: 'especificación', request: @request)
        @request.update(specification_document: true)
        @request.save
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

  def set_authorisation_flag
    check_document_authorisation
    check_payment_authorisation
    if (@doc_ok == true && @pay_ok == true)
      if @request.sensitive_fields_changed != true
        @request.authorised = true
      else
        @request.authorised = false
      end
    end
  end

  def save_status
    set_authorisation_flag
    sensitive_fields_changed_after_price_set
    debugger
    if params[:enviar] || params[:reactivar]
      @request.status = 'solicitada'
    elsif params[:guardar]
      @request.status = 'creada'
    elsif ((@sensitive_fields_changed || @request.sensitive_fields_changed) && @request.internal_price.present?)
      @request.status = 'modificada-recotizar'
    elsif params[:modificar_cotización]
      @request.status = @request.status
    elsif @request.authorised ==  true
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
    if @request.status == 'autorizada'
      redirect_to request_path(@request), notice: 'Esta solicitud ya fue autorizada.'
    elsif @request.status != 'autorizada'
      redirect_to confirm_view_requests_path(@request)
    end
  end

  def sensitive_fields_changed_after_price_set
    @any_sensitive_field_changed = false
    if @request.status == 'precio asignado' || @request.status == 'costo asignado' || @request.status == 'autorizada'
      if ((@request.product_type == 'caja' || @request.product_type == 'otro') && @request.what_measures == '1')
        if (params[:request][:outer_length] || params[:request][:outer_width] || params[:request][:outer_height] || params[:request][:main_material] || params[:request][:resistance_main_material] || params[:request][:quantity])
          @any_sensitive_field_changed = true
        end
      elsif ((@request.product_type == 'caja' || @request.product_type == 'otro') && @request.what_measures == '2')
        if (params[:request][:inner_length] || params[:request][:inner_width] || params[:request][:inner_height] || params[:request][:main_material] || params[:request][:resistance_main_material] || params[:request][:quantity])
          @any_sensitive_field_changed = true
        end
      elsif ((@request.product_type == 'caja' || @request.product_type == 'otro') && @request.what_measures == '3')
        if (params[:request][:inner_length] || params[:request][:inner_width] || params[:request][:inner_height] || params[:request][:outer_length] || params[:request][:outer_width] || params[:request][:outer_height] || params[:request][:main_material] || params[:request][:resistance_main_material] || params[:request][:quantity])
          @any_sensitive_field_changed = true
        end
      elsif @request.product_type == 'bolsa'
        if (params[:request][:bag_length] || params[:request][:bag_width] || params[:request][:bag_height] || params[:request][:main_material] || params[:request][:resistance_main_material] || params[:request][:quantity])
          @any_sensitive_field_changed = true
        end
      elsif @request.product_type == 'exhibidor'
        if (params[:request][:exhibitor_height] || params[:request][:tray_quantity?] || params[:request][:tray_length] || params[:request][:tray_width] || params[:request][:tray_divisions] || params[:request][:main_material] || params[:request][:resistance_main_material] || params[:request][:quantity])
          @any_sensitive_field_changed = true
        end
      end
      if @any_sensitive_field_changed
        @request.update(sensitive_fields_changed: true)
        @request.save
      else
        @request.update(sensitive_fields_changed: false)
        @request.save
      end
    end
  end

  def delete_authorisation_or_payment
    sensitive_fields_changed_after_price_set
    if (@any_sensitive_field_changed && (@request.status == 'autorizada' || @request.status == 'precio asignado' || @request.status == 'costo asignado' || @request.status == 'modificada-recotizar'))
      d = @request.documents.where("(document_type= ? OR document_type= ?)", "pago", "pedido")
      if d
        d.each do |document|
          document.destroy
        end
      end
      @request.authorised_without_pay = nil
      @request.payment_uploaded = nil
      @request.payment = nil
      @request.authorised_without_doc = nil
      @request.authorisation_signed = nil
      @request.authorisation = nil
      @request.authorised = nil
      @request.save
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
       :outer_width,
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
       :specification_document,
       :payment,
       :authorisation,
       :sensitive_fields_changed,
       :authorised)
    end
end
