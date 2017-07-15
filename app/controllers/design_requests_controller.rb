class DesignRequestsController < ApplicationController
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

  def create
    @request = Request.find(params[:request_id])
    @design_request = DesignRequest.new(design_params)
    upload_attachment
    assign_to_current_user
    debugger
    @design_request.status = 'solicitada'
    respond_to do |format|
      if @design_request.save
        debugger
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

  def update
    upload_attachment
    assign_to_current_user
    respond_to do |format|
      if @design_request.update(design_params)
        if current_user.role.name == 'designer' && params[:asignar_solicitud]
          format.html {redirect_to edit_design_request_path(@design_request), notice: "La solicitud fue asignada a #{current_user.first_name} #{current_user.last_name}" }
        elsif params[:aceptar_diseño]
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

  def upload_attachment
    if (params[:design_request][:attachment].present? && current_user.role.name == 'store')
      params[:design_request][:attachment].each do |file|
        @design_request.documents << Document.create(document: file, document_type: 'diseño adjunto', design_request: @design_request)
      end
    elsif (params[:design_request][:attachment].present? && current_user.role.name == 'designer')
      params[:design_request][:attachment].each do |file|
        @design_request.documents << Document.create(document: file, document_type: 'respuesta de diseño', design_request: @design_request)
      end
    end
  end

  def get_documents
    @attachments = @design_request.documents.where(document_type: 'diseño adjunto')
    @responses = @design_request.documents.where(document_type: 'respuesta de diseño')
  end

# Método para managers o designers: asigna la solicitud si no hay otro usuario con el mismo rol en la solicitud
  def assign_to_current_user(user = current_user, role = current_user.role.name)
    users = User.joins(:role).where('roles.name' => (role))
    user_find = false
    @design_request.users.each do |user|
      users.each do |other_user|
        if (user.id == other_user.id)
          user_find = true
        end
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
