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

  def update
    upload_authorisation_payment
    upload_authorisation_document
    assign_to_current_user
    assign_design_request
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
