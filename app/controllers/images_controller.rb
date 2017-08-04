class ImagesController < ApplicationController
  # Este controller es para todos los documentos tanto de DesignRequests como de Requests, crea y borra documentos.
  before_action :authenticate_user!
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    Image.new = Image.new(document_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'La imagen fue creada.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(document_params)
        format.html { redirect_to @image, notice: 'La imagen fue actualizada.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    redirect_to :back, notice: 'La imagen fue eliminado correctamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

end
