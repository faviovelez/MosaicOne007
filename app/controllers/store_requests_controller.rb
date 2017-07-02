class StoreRequestsController < ApplicationController
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
        format.html { redirect_to @request, notice: 'La solicitud de diseño fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @design_request }
      else
        format.html { render :new }
        format.json { render json: @design_request.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @biling.update(design_params)
        format.html { redirect_to @request, notice: 'La solicitud de diseño fuer modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Requests/1
  # DELETE /Requests/1.json
  def destroy
    @design_request.destroy
    respond_to do |format|
      format.html { redirect_to @request, notice: 'La solicitud de diseño fue eliminada correctamente' }
      format.json { head :no_content }
    end
  end

  def authorise
  end

  def upload_authorisation_document
    if params[:request][:authorisation_signed].nil?
      @request.authorisation_signed = false
    else
      @request.documents << Document.create(documents params[:request][:authorisation_signed],
      document_type: 'pedido', request: @request)
      @request.authorisation_signed = true
    end
  end

  def upload_authorisation_payment
    if params[:request][:payment_uploaded].nil?
      @request.payment_uploaded = false
    else
      @request.documents << Document.create(document: params[:request][:payment_uploaded],
      document_type: 'pago', request: @request)
      @request.payment_uploaded = true
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
