class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :create, :update, :destroy]

  def index
  end

  def new
    debugger
    @user = User.new(user_params)
  end

  def savenew
  end

  def show
  end

  def create
    @user = User.new(user_params)
    debugger
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'El usuario fue dado de alta exitosamente.' }
        format.json { render :index, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    @user.skip_notifications!
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'El usuario fue modificado exitosamente.' }
        format.json { render :index, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    @user.skip_notifications!
  end


private

def user_params
  params.permit(:first_name, :middle_name, :last_name, :store_id, :role_id, :email, :password, :password_confirmation)
end

def set_user
  @user = User.find(params[:id])
end


end
