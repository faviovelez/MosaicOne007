class AssignedRequestsController < ApplicationController
  before_action :set_request
  before_action :filter_requests, only: [:assigned, :unassigned]

  def index
    filter_requests_assigned_to_user
    filter_requests_assigned_to_others
    all_assigned_requests_to_managers
  end

  def show
  end

  def set_current_user
    @user = current_user
    @user
  end

  def filter_requests_assigned_to_user
    set_current_user
    @assigned = @user.requests.where.not('status' => ['creada','expirada','cancelada'])
    @assigned
  end

  def filter_requests_assigned_to_others(set_current_user)
    debugger
    @assigned_to_others = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' => 'manager').where.not('users.name' => (set_current_user))
    debugger
    @assigned_to_others
  end

  def all_assigned_requests_to_managers
    @manager_assigned = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' => 'manager')
    @manager_assigned
  end

  def all_assigned_requests_to_designers
  end


private


  def set_request
    @request = Request.find(params[:id])
  end

end
