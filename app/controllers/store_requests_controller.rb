class StoreRequestsController < ApplicationController
  before_action :authenticate_user!
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

end
