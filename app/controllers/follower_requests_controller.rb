class DesignRequestsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @request = Request.find(params[:request_id])
    @design_request = DesignRequest.new
  end

  def create
    @request = Request.find(params[:request_id])
    @design_request = DesignRequest.new(design_params)
    respond_to do |format|
      if @design_request.save
        @request.design_request = @design_request
        @request.save
        format.html { redirect_to @request, notice: 'La(s) solicitud(es) de diseño fueron creadas exitosamente.' }
        format.json { render :show, status: :created, location: @design_request }
      else
        format.html { render :new }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
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

    def assigned
      manager_assigned_requests
    end

    def unassigned
      manager_unassigned_requests
    end

    def assigned_to_designer
      designer_assigned_requests
    end

private

def design_params
  params.require(:design_request).permit(:design_type,
         :cost,
         :status,
         :authorisation,
         :attachment,
         :outcome,
         :request_id,
         :description)
end

end
