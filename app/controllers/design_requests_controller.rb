class DesignRequestsController < ApplicationController
  # Este controller es para las solicitudes de diseño. Dentro de cada request, un usuario de Store puede solicitar un trabajo de diseño (hacer un logo, crear una muestra física o un printcard) en cualquier etapa del proceso, excepto cuando está cancelada o concluida, pero esto se restringe en las vistas.
  before_action :authenticate_user!
  before_action :set_design_request, only: [:show, :edit, :update, :destroy]
  before_action :get_documents, only: [:edit, :show]

  def index
  end

  def show
  end

  def edit
  end

  def new
    @request = Request.find(params[:request_id])
    @design_request = DesignRequest.new
  end

  # Las solicitudes de diseño las cran los usuarios de 'store', le dan seguimiento los usuarios 'designer'. Este método crea las solicitudes y las asigna al usuario store. Las solicitudes pueden tener archivos adjuntos, se guardan en el modelo document y se relacionan con la solicitud de diseño.
  # Se guarda el campo design_request como true para identificar que la solicitud tiene una solicitud de diseño y se relaciona la request (solicitud de cotización) con la design request (solicitud de diseño).
  def create
    @request = Request.find(params[:request_id])
    @design_request = DesignRequest.new(design_params)
    upload_attachment
    assign_to_current_user
    @design_request.status = 'solicitada'
    respond_to do |format|
      if @design_request.save
        @request.require_design = true
        @request.design_requests << @design_request
        @request.save
        format.html { redirect_to @design_request, notice: 'La solicitud de diseño fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @design_request }
      else
        format.html { render new_request_design_request_path }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
    end
  end

# Este método sirve tanto para que el usuario 'store' como el usurio 'designer' actualicen la solicitu de diseño. Los campos que cada persona puede editar los estoy filtrando desde la vista.
  def update
    upload_attachment
    assign_to_current_user
    respond_to do |format|
      if @design_request.update(design_params)
        format.html {redirect_to filtered_requests_assigned_view_path, notice: "La solicitud de diseño fue atendida" }
        # Esta parte asigna la solicitud (agrega un usuario con role: 'designer') a la solicitud de diseño y lo redirige a la página para trabajar la solicitud de diseño.
        if current_user.role.name == 'designer' && params[:asignar_solicitud]
          format.html {redirect_to edit_design_request_path(@design_request), notice: "La solicitud fue asignada a #{current_user.first_name} #{current_user.last_name}" }
        elsif params[:aceptar_diseño]
          # Si el usuario 'store' se encuentra en la vista donde puede aceptar el diseño (porque tiene que confirmar el costo), cambia el estatus a 'aceptada'.
          @design_request.update(status: 'aceptada')
          format.html { redirect_to @design_request, notice: 'La solicitud de diseño fue modificada exitosamente.' }
          format.json { render :index, status: :ok, location: @design_request }
        end
      else
        format.html { render :edit }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # Borré el método de delete porque prefiero agregar solo una funcionalidad de 'cancelada' para tratar de no borrar casi nada de la plataforma.

  # Este método controla los archivos adjuntos que se pueden adjuntar (pueden ser muchos) a la solicitud de diseño y los separa por usuario por tipo de documento.
  def upload_attachment
    if (params[:design_request][:attachment].present? && (current_user.role.name == 'store' || current_user.role.name == 'store-admin'))
      params[:design_request][:attachment].each do |file|
        @design_request.documents << Document.create(document: file, document_type: 'diseño adjunto', design_request: @design_request)
      end
    elsif (params[:design_request][:attachment].present? && current_user.role.name == 'designer')
      params[:design_request][:attachment].each do |file|
        @design_request.documents << Document.create(document: file, document_type: 'respuesta de diseño', design_request: @design_request)
      end
    end
  end

  # Muestra los documentos en las vistas de design request, separados por tipo.
  def get_documents
    @attachments = @design_request.documents.where(document_type: 'diseño adjunto')
    @responses = @design_request.documents.where(document_type: 'respuesta de diseño')
  end

# Método para managers o designers: asigna la solicitud si no hay otro usuario con el mismo rol en la solicitud
  def assign_to_current_user(user = current_user, role = current_user.role.name)
    user_find = false
    @design_request.users.each do |user|
      if user.role.name == (role)
        user_find = true
      end
    end
    if user_find == false
      @design_request.users << user
    end
  end

private
  def set_design_request
    @design_request = DesignRequest.find(params[:id])
  end

def design_params
  params.require(:design_request).permit(:design_type,
         :cost,
         :status,
         :authorisation,
         :attachment,
         :request_id,
         :description,
         :notes)
end

end
