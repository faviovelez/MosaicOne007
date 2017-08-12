class BusinessGroupsController < ApplicationController
  # Este controller es para crear o modificar Corporativos.
  before_action :authenticate_user!
  before_action :set_business_group, only: [:show, :edit, :update, :destroy]

  # BusinessGroup (empresa) debe pertenecer a un owner (que puede ser una tienda o a una Business Unit
  before_action :identify_owner_type, only: [:new, :create]

  def show
  end

  def edit
  end

  def new
    @business_group = BusinessGroup.new
  end

  def create
    @business_group = BusinessGroup.new(business_group_params)
    respond_to do |format|
      if @business_group.save
        format.html { redirect_to @business_group, notice: 'El corporativo fue creado correctamente.' }
        format.json { render :show, status: :created, location: @business_group }
      else
        format.html { render :new }
        format.json { render json: @business_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @business_group.update(business_group_params)
        format.html { redirect_to @business_group, notice: 'El corporativo fue modificado correctamente.' }
        format.json { render :show, status: :ok, location: @business_group }
      else
        format.html { render :edit }
        format.json { render json: @business_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @business_group.destroy
    respond_to do |format|
      format.html { redirect_to @owner, notice: 'El corporativo fue eliminado correctamente' }
      format.json { head :no_content }
    end
  end

private

  def set_business_group
    @business_group = BusinessGroup.find(params[:id])
  end


  def business_group_params
      params.require(:business_group).permit(:name)
  end

end
