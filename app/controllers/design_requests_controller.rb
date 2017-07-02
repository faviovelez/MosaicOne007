class DesignRequestsController < ApplicationController
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
    @design_request.status = 'solicitada'
    respond_to do |format|
      if @design_request.save
        @request.require_design = true
        @request.design_requests << @design_request
        @request.save
        format.html { redirect_to @request, notice: 'La solicitud de diseño fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @design_request }
      else
        format.html { render new_request_design_request_path }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    upload_attachment
    respond_to do |format|
      if @design_request.update(request_params)
        format.html { redirect_to design_requests_index_path, notice: 'La solicitud de diseño fue modificada exitosamente.' }
        format.json { render :index, status: :ok, location: @design_request }
      else
        format.html { render :edit }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_attachment
    if params[:design_request][:attachment].present?
      params[:design_request][:attachment].each do |file|
        @design_request.documents << Document.create(document: file, document_type: 'diseño adjunto', design_request: @design_request)
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
         :request_id,
         :description)
end

end
