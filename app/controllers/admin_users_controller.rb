class AdminUsersController < ApplicationController
  before_action :set_admin_user, only: [:show, :edit, :update]

  def index
  end

  def new
    @admin_user = User.new(admin_user_params)
  end

  def show
  end

  def create
    @admin_user = User.new(admin_user_params)
    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to root_path, notice: 'El usuario fue dado de alta exitosamente.' }
        format.json { render :index, status: :created, location: @admin_user }
      else
        format.html { render :new }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
    @admin_user.skip_notifications!
  end

  def edit
    @admin_user = User.find(params[:id])
  end

  def update
    if params[:admin_user][:password].blank?
      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @admin_user.update(admin_user_params)
        format.html { redirect_to root_path, notice: 'El usuario fue modificado exitosamente.' }
        format.json { render :index, status: :created, location: @admin_user }
      else
        format.html { render :new }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
    @admin_user.skip_notifications!
  end


private

  def admin_user_params
    params.require(:admin_user).permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation)
  end

  def set_admin_user
    @admin_user = User.find(params[:id])
  end


end
