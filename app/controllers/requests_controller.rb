class RequestsController < ApplicationController
# Este controller solo debe manejar la creación y modificación de requests individuales por la tienda o managers, no los filtros para las bandejas de trabajo.
  before_action :authenticate_user!
  layout 'authorisation', only: [:authorisation_doc, :authorisation_page]
  layout 'estimate', only: [:estimate_doc, :estimate_page]

  before_action :set_request, only: [
                                      :show,
                                      :edit,
                                      :update,
                                      :destroy,
                                      :check_assigned,
                                      :manager,
                                      :manager_view,
                                      :manager_after,
                                      :confirm,
                                      :confirm_view,
                                      :price,
                                      :delete_authorisation_or_payment,
                                      :sensitive_fields_changed_after_price_set,
                                      :estimate_doc,
                                      :estimate_page,
                                      :authorisation_doc,
                                      :authorisation_page
                                    ]

  before_action :get_documents, only: [
                                        :edit,
                                        :show,
                                        :confirm,
                                        :confirm_view,
                                        :manager,
                                        :manager_view,
                                        :manager_after
                                      ]


  # GET /requests
  # GET /requests.json
  # Un Request siempre debe estar ligado a un Prospect cuando se crea.
  def index
    @prospect = Prospect.find(params[:prospect_id])
    @requests = @prospect.requests.order(:created_at)
  end

  def estimate_page
  end

  def authorisation_page
  end

  def estimate_doc
    filename = "cotización-#{@request.store.store_name}-#{@request.id}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'requests/estimate_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'estimate.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def authorisation_doc
    filename = "pedido-#{@request.store.store_name}-#{@request.id}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'requests/authorisation_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'authorisation.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def send_authorisation_mail
    request = Request.find(params[:id])
    if (!request.prospect.email.present? && !request.prospect.email_2.present? && !request.prospect.email_3.present?)
      redirect_to filtered_requests_current_view_path, alert: 'El cliente no tiene correo registrado'
    else
      RequestMailer.send_authorisation(request).deliver_now
      redirect_to filtered_requests_current_view_path, notice: 'Se ha enviado el correo de autorización'
    end
  end

  def send_estimate_mail
    request = Request.find(params[:id])
    if (!request.prospect.email.present? && !request.prospect.email_2.present? && !request.prospect.email_3.present?)
      redirect_to filtered_requests_current_view_path, alert: 'El cliente no tiene correo registrado'
    else
      RequestMailer.send_estimate(request).deliver_now
      redirect_to filtered_requests_current_view_path, notice: 'Se ha enviado el correo de cotización'
    end
  end

  def authorisation_mail_doc
    filename = "pedido-#{@request.store.store_name}-#{@request.id}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'requests/authorisation_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'authorisation.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def estimate_mail_doc
    filename = "cotización-#{@request.store.store_name}-#{@request.id}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'requests/estimate_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'estimate.html',
        show_as_html: params[:debug].present?
      }
    end
  end


  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # Esta acción es para que los managers asignen la Request a su usuario. El método revisa que esté asignada y si es así las pasa a la siguiente pantalla.
  def manager
    check_assigned
  end

  # Esta acción es solo para managers y es la pantalla donde se le asigna el precio o se emiten comentarios de que la Request está incompleta.
  def manager_view
  end

  # Esta acción es para después que el manager ha enviado dudas.
  def manager_after
  end

  # Esta acción es para los usuarios 'store' para confirmar que sí están de acuerdo con la Request y la autorizan.
  def confirm
    check_authorisation
  end

  # En esta acción es también para los usuarios 'store' casi igual que la anterior pero muestra los links a los documentos de autorización adjuntos.
  def confirm_view
  end

  # Esta acción es para que los usuarios 'store asignen el precio de venta al público de la cotización que hicieron', se puede ver solo cuando la solicitud tenga costo.
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
    params[:request][:impression_finishing].sort!.reverse!.pop
    params[:request][:impression_finishing].each do |item|
      @request.impression_finishing << item
    end
    # Esta parte es para evitar que el campo se guarde en blanco.
    if params[:request][:how_many] == ''
      @request.how_many = nil
    end
    # Este método guarda el documento y el campo que detecta si está presente el documento, ya sea de especificaciones (document_type: 'specification') para la Request o de Ficha de depósito (document_type: 'pago') o Pedido autorizado (document_type: 'pedido')
    save_document
    # Este método guarda el estatus de si la solicitud tiene solicitud de diseño.
    # request_has_design?
    # Este método asigna al usuario actual (solo un usuario por tipo de role).
    assign_to_current_user
    # Este método asigna la tienda a la Request.
    save_store_request
    # Este método asigna el prospecto a la Request.
    save_prospect_to_request
    # Este método actualiza el estatus de la request.
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
    # Este método salva el estatus anterior de la solicitud
    save_last_status
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      # Este método guarda el estatus de si la solicitud tiene solicitud de diseño.
      # request_has_design?
      @request.update(request_params)
      # Este método borra las autorizaciones o pagos guardados cuando se modifica la solicitud.
      delete_authorisation_or_payment
      # Este método guarda el documento y el campo que detecta si está presente el documento, ya sea de especificaciones (document_type: 'specification') para la Request o de Ficha de depósito (document_type: 'pago') o Pedido autorizado (document_type: 'pedido')
      save_document
      # Este método detecta si la solicitud está autorizada.
      validate_authorisation
      # Este método guarda el estatus de la autorización en unas variables de instancia.
      set_authorisation_flag
      # Este método actualiza el estatus de la request.
      save_status
      # Esta bifurcación del método es para cambiar el estatus a cancelada.
      if params[:cancelar].present?
        @request.update(status: 'cancelada')
        @request.save
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
      # Esta bifurcación del método es para cambiar el estatus cuando se asignó la Request a un 'manager'.
    elsif current_user.role.name == 'manager' || current_user.role.name == 'director'
      save_status
      @request.save
      if @request.update(request_params) && params[:asignar]
        assign_to_manager
        redirect_to manager_view_requests_path(@request), notice: "La solicitud fue asignada a #{current_user.first_name} #{current_user.last_name}"
      elsif @request.update(request_params) && params[:enviar_dudas]
        redirect_to manager_after_path(@request), notice: "Los comentarios fueron enviados a la tienda."
      elsif @request.update(request_params)
        @request.update(sales_price: params[:request][:internal_price].to_f, status: 'precio asignado') if (@request.store.store_type.store_type == 'tienda propia' && params[:request][:internal_price].present? && params[:request][:internal_cost].present?)
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
  # Este método aún no está disponible y quizás lo eliminaré para solo cancelar las solicitudes.
  def destroy
    find_user_in_request(user = current_user)
    if user_find
      @request.destroy
      respond_to do |format|
        format.html { redirect_to requests_url, notice: 'La solicitud de cotización fue eliminada correctamente.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: 'Solo el usuario que creó esta solicitud o el administrador de tienda pueden borrar esta solicitud'
    end
  end

  # Este método valida si ya se ha asignado el costo, es el que permite o niega el acceso a la vista de confirm.
  def check_price
    if @request.status != 'costo asignado'
      redirect_to request_path(@request)
    end
  end

  # Este método valida si ya se asignó la solicitud al 'manager' y si es así, redirige a la vista para seguir cotizando.
  def check_assigned
    redirect_to manager_view_requests_path(@request) if @request.status == 'cotizando'
  end

  # Este método muestra los documentos adjuntos en las vistas de cada Request individual.
  def get_documents
    @payment = @request.documents.where(document_type: 'pago')
    @authorisation = @request.documents.where(document_type: 'pedido')
    @specifications = @request.documents.where(document_type: 'especificación')
  end

  # Este método valida si el usuario está en la solicitud, posteriormente lo utilizaré para la seguridad, solo los usuarios ligados a la request (o de la misma tienda del usuario creador de la request podrán verla).
  def find_user_in_request(user = current_user)
    user_find = false
    @request.users.each do |user_in_request|
      if (user_in_request.id == user.id)
        user_find = true
      end
    end
    user_find
  end

  # Este método es para una búsqueda dentro del formulario, solo valida si se buscará en uno u otro campo de la tabla Product.
  def define_search_field(input = params[:request][:resistance_like])
    if Product.find_by_unique_code(input) != nil
      @product = Product.find_by_unique_code(input)
    elsif Product.find_by_former_code(input) != nil
      @product = Product.find_by_former_code(input)
    end
  end

  # Este método valida si se llenó o no el campo de búsqueda de resistencia o tipo de armado como algún otro producto existente.
  def request_has_design?
    if params[:request][:design_like]
      search_design
    end
    if params[:request][:resistance_like]
      search_resistance
    end
  end

  # Este método busca en la tabla producto el cógigo de producto que el usuario puso para buscar alguno, si encuentra el cógidog, trae el tipo de armado de ese producto y lo guarda en la base, de lo contrario, guarda lo que el usuario puso, ejemplo: tipo de armado: 'caja regular'
  def search_design(input = params[:request][:design_like])
    define_search_field
    if (input != nil) && (@product != nil)
      @request.design_like = @product.design_type
    elsif (input != nil) && (@product == nil)
      @request.design_like = input
    end
  end

  # Misma funcionalidad del método anterior pero para la resistencia de una caja igual a la de otro producto existente.
  def search_resistance(input = params[:request][:resistance_like])
    define_search_field
    if (input != nil) && (@product != nil)
      @request.design_like = @product.design_type
      @request.resistance_like = @product.resistance_main_material
    elsif (input != nil) && (@product == nil)
      @request.resistance_like = input
    end
  end

  # Guarda el prospecto a la request.
  def save_prospect_to_request
    @prospect = Prospect.find(params[:prospect_id])
    @request.prospect = @prospect
  end

  # GUarda la tienda a la request
  def save_store_request(store = current_user.store)
    @request.store = store
  end

# Método para managers, director, o designers: asigna la solicitud si no hay otro usuario con el mismo rol en la solicitud
  def assign_to_current_user(user = current_user, role = current_user.role.name)
    user_find = false
    if role == 'manager' || role == 'director'
      @request.users.each do |user|
        if user.role.name == 'manager' || user.role.name == 'director'
            user_find = true
        end
      end
    else
      @request.users.each do |user|
        if user.role.name == (role)
            user_find = true
        end
      end
    end
    if user_find == false
      @request.users << user
    end
  end

  # Asigna la solicitud al manager que está solicitando le sea asignada.
  def assign_to_manager
    if params[:asignar]
      assign_to_current_user
    end
  end

  # Guarda el documento y el estatus del campo que dice si se guardó el documento.
  def save_document
    if params[:request][:payment].present?
      payment = Document.create(document: params[:request][:payment], document_type: 'pago', request: @request)
      @request.documents << payment
      @request.update(payment_uploaded: true)
      @request.save
    end
    if params[:request][:authorisation].present?
      authorisation = Document.create(document: params[:request][:authorisation], document_type: 'pedido', request: @request)
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

  # Valida si se autorizó con un click la Request.
  def validate_authorisation
    if params[:request][:authorised_without_pay] == '1'
      @request.authorised_without_pay = true
    end
    if params[:request][:authorised_without_doc] == '1'
      @request.authorised_without_doc = true
    end
  end

  # Valida si se autorizó con documento de pedido la solicitud.
  def check_document_authorisation
    @doc_ok = false
    if( @request.authorised_without_doc == true) || (@request.authorisation_signed == true)
      @doc_ok = true
    end
    @doc_ok
  end

  # Valida si se autorizó con ficha de depósito la solicitud.
  def check_payment_authorisation
    @pay_ok = false
    if (@request.payment_uploaded == true) || (@request.authorised_without_pay == true)
      @pay_ok = true
    end
    @pay_ok
  end

  # Si tiene pedido y ficha de depósito o autorización con click, autoriza la solicitud.
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

  # Guarda y cambia los estatus de la Request.
  def save_status
    set_authorisation_flag
    sensitive_fields_changed_after_price_set
    if params[:enviar].present?
      @request.status = 'solicitada'
    elsif params[:guardar].present?
      @request.status = 'creada'
    elsif ((@sensitive_fields_changed || @request.sensitive_fields_changed) && @request.internal_price.present?)
      @request.status = 'modificada-recotizar'
    elsif params[:modificar_cotización].present?
      @request.status = @request.status
    elsif @request.authorised ==  true
      @request.status = 'autorizada'
    elsif params[:cancelar].present?
      @request.status = 'cancelada'
    elsif params[:asignar].present?
      @request.status = 'cotizando'
    elsif params[:enviar_dudas].present?
      @request.status = 'devuelta'
    elsif params[:request][:internal_price].present?
      @request.status = 'costo asignado'
    elsif params[:request][:sales_price].present?
      @request.status = 'precio asignado'
    end
  end

  # Revisa si ya se autorizó la solicitud para que el usuario no vuelva a entrar a esta pantalla.
  def check_authorisation
    if @request.status == 'autorizada'
      redirect_to request_path(@request), notice: 'Esta solicitud ya fue autorizada.'
    elsif @request.status != 'autorizada'
      redirect_to confirm_view_requests_path(@request)
    end
  end

  # Revisa si los campos que hacen que cambie el precio fueron modificados después de asignar precio.
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

  # Borra los documentos y autorizaciones con clicks de la solicitud si se regresa el estatus después de haberse modificado los campos que requieren recotizar.
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

  def save_last_status
    @value = @request.status
    if @request.status != 'cancelada'
      @request.update(last_status: @request.status)
      @request.save
    end
    assign_reactivate_status
    @request.update(last_status: @value)
    @request.save
  end

  def assign_reactivate_status
    if params[:reactivar].present?
      if (@request.last_status == nil || @request.last_status.blank?)
        @request.update(status: 'solicitada')
        @request.save
      else
        @request.update(status: @request.last_status)
        @request.save
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
       :authorised,
       :last_status,
       :has_window,
       :develop)
    end
end
