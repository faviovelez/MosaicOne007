class FilteredRequestsController < ApplicationController
  before_action :days_since

  def days_since
    a = Date.today
    date = @request.created_at.to_date
    @days_since = (a - date).to_i
  end

  def current_view
    filter_store_active_requests
  end

  def cancelled_view
    filter_store_inactive_requests
  end

  def saved_view
    filter_store_saved_requests
  end

  def assigned_view
    filter_requests_assigned_to_user
  end

  def unassigned_view
    filter_unassigned_requests
  end

  def other_users_view
    filter_requests_assigned_to_others
  end

  def supporters_view
    filter_supporters_view
  end

# Método de tienda: muestra solicitudes activas
  def filter_store_active_requests(store = current_user.store)
    @store_active = store.requests.where.not('status' => ['creada','expirada','cancelada'])
    @store_active
  end

# Método de tienda: muestra solicitudes expiradas y canceladas
  def filter_store_inactive_requests(store = current_user.store)
    @store_inactive = store.requests.where('status' => ['expirada','cancelada'])
    @store_inactive
  end

# Método de tienda: muestra solicitudes guardadas
  def filter_store_saved_requests(store = current_user.store)
    @store_saved = store.requests.where('status' => 'creada')
    @store_saved
  end

# Método de managers y designers: muestra solicitudes o solicitudes de diseño asignadas al usuario logueado
  def filter_requests_assigned_to_user(user = current_user)
    if user.role.name == 'manager'
      @assigned = user.requests.where.not('status' => ['creada','expirada','cancelada'])
    elsif user.role.name == 'designer'
      @assigned = user.design_requests.where.not('status' => ['concluida','expirada','cancelada'])
    end
      @assigned
  end

# Método para managers exclusivo para el Dr. Luis, para ver las solicitudes asignadas a otros gerentes
  def filter_requests_assigned_to_others(user = current_user)
    @assigned_to_others = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' => 'manager').where.not('users.id' => (user))
    @assigned_to_others
  end

# Método para managers y designers: muestra las solicitudes o solicitudes de diseño sin asignar
  def filter_unassigned_requests(role = current_user.role.name)
    if role == 'manager'
      requests = Request.where.not('status' => ['creada','expirada','cancelada'])
      assigned = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' => (role))
    elsif role == 'designer'
      requests = DesignRequest.where.not('status' => ['concluida','expirada','cancelada'])
      assigned = DesignRequest.where.not('status' => ['concluida','expirada','cancelada']).joins(user: :role).where('roles.name' => (role))
    end
    @unassigned = requests - assigned
    @unassigned
  end

# Este método sirve para que usuarios con roles distintos a Manager o Designer puedan ver el estatus
  def filter_supporters_view
    @supporters = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' => 'manager')
    @supporters
  end

end
