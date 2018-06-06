class AdminUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def index(role = current_user.role.name)
    @users = User.all
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless role == 'platform-admin'
  end

  def new
    @user = User.new
  end

  def show
    valid_roles
    role = current_user.role.name
    @user = User.find(params[:id])
    edit_user_role = @user.role.name
    edit_store_id = @user.store.id
    store_id = current_user.store.id
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (@role_options[role].include?(edit_user_role) && store_id == edit_store_id || (role == 'platform-admin'))
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_path(@user), notice: 'El usuario fue dado de alta exitosamente.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    valid_roles
    role = current_user.role.name
    @user = User.find(params[:id])
    edit_user_role = @user.role.name
    edit_store_id = @user.store.id
    store_id = current_user.store.id
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios.' unless (@role_options[role].include?(edit_user_role) && store_id == edit_store_id || (role == 'platform-admin'))
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: 'El usuario fue modificado exitosamente.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def valid_roles
    @role_options = {
      'platform-admin' => [
        'store',
        'store-admin',
        'warehouse-staff',
        'warehouse-admin',
        'product-staff',
        'product-admin',
        'director',
        'manager',
        'designer-admin',
        'designer',
        'viewer',
        'admin-desk'
      ],
      'store-admin' => ['store', 'store-admin'],
      'store' => ['store'],
      'warehouse-admin' => ['warehouse-staff', 'warehouse-admin'],
      'warehouse-staff' => ['warehouse-staff'],
      'product-admin' => ['product-staff', 'product-admin'],
      'product-staff' => ['product-staff'],
      'director' => ['director', 'manager'],
      'manager' => ['manager'],
      'designer-admin' => ['designer-admin', 'designer'],
      'designer' => ['designer'],
      'viewer' => ['viewer'],
      'admin-desk' => ['admin-desk']
    }
  end

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end


end
