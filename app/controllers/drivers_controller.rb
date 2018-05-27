class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver, only: [:update, :edit]

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.create(first_name: params[:driver][:first_name], last_name: params[:driver][:last_name])
    redirect_to drivers_path, notice: 'El chofer se ha registrado correctamente'
  end

  def update
    @driver.update(first_name: params[:driver][:first_name], last_name: params[:driver][:last_name] )
    redirect_to drivers_path, notice: 'Los datos del chofer se han actualizado correctamente'
  end

  def edit
  end

  def index
    @drivers = Driver.all
  end

  def set_driver
    @driver = Driver.find(params[:id])
  end

end
