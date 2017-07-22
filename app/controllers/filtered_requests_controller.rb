class FilteredRequestsController < ApplicationController
  before_action :authenticate_user!

  # Método para usuarios 'store' para filtrar las solicitudes activas y crear la vista de bandeja de trabajo (un resumen de que contiene esa Request o solicitud de cotización).
  def current_view
    filter_store_active_requests
  end

  # Método para usuarios 'store' para filtrar las solicitudes inactivas y crear la vista de bandeja de trabajo.
  def inactive_view
    filter_store_inactive_requests
  end

  # Método para usuarios 'store' para filtrar las solicitudes guardadas (que crearon pero no enviaron, para poder editar después y posteriormente enviar a cotización con los usuarios 'manager'), crea la vista de bandeja de trabajo .
  def saved_view
    filter_store_saved_requests
  end

  # Método para usuarios 'designer', 'manager' y 'director' para ver las solicitudes que ya están asignadas a ellos, es la vista de bandeja de trabajo.
  def assigned_view
    filter_requests_assigned_to_user
  end

  # Método para usuarios 'designer', 'manager' y 'director' para ver las solicitudes en general que no están asignadas a ellos. Es la vista de la bandeja de trabajo. Al ver la solicitud, ellos pueden asignarlas con un botón.
  def unassigned_view
    filter_unassigned_requests
  end

  # Este método lo uso para el dueño de la empresa, para que vea el estatus de las solicitudes que están asignadas a las otras personas que pueden cotizar 'managers'.
  def other_users_view
    filter_requests_assigned_to_others
  end

  # Este método es para crear la bandeja de trabajo para que otros gerentes puedan dar seguimiento a las solicitudes (asignadas y sin asignar).
  def supporters_view
    filter_supporters_view
  end

  # Este método es para crear la bandeja de trabajo para los usuarios 'product-admin' para que puedan ver las solicitudes confirmadas que necesitan que se cree un nuevo producto.
  def product_view
    filter_confirmed_requests
  end

# Método de tienda: muestra solicitudes activas
  def filter_store_active_requests(store = current_user.store)
    @store_active = store.requests.where.not('status' => ['creada','expirada','cancelada']).order(:created_at).order(:store_code)
    @store_active
  end

# Método de tienda: muestra solicitudes expiradas y canceladas
  def filter_store_inactive_requests(store = current_user.store)
    @store_inactive = store.requests.where('status' => ['expirada','cancelada']).order(:created_at).order(:store_code)
    @store_inactive
  end

# Método de tienda: muestra solicitudes guardadas
  def filter_store_saved_requests(store = current_user.store)
    @store_saved = store.requests.where('status' => 'creada').order(:created_at).order(:store_code)
    @store_saved
  end

# Método de managers, director y designers: muestra solicitudes o solicitudes de diseño asignadas al usuario logueado
  def filter_requests_assigned_to_user(user = current_user, role = current_user.role.name)
    if role == 'manager' || role == 'director'
      @assigned = user.requests.where.not('status' => ['creada','expirada','cancelada']).order(:created_at).order(:store_code)
    elsif role == 'designer'
      @assigned = user.design_requests.where.not('status' => ['concluida','expirada','cancelada']).order(:created_at)
    end
      @assigned
  end

# Método para director exclusivo para el Dr. Luis, para ver las solicitudes asignadas a otros gerentes
  def filter_requests_assigned_to_others(user = current_user)
    @assigned_to_others = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where('roles.name' =>  'director').where.not('users.id' => (user)).order(:created_at).order(:store_code)
    @assigned_to_others
  end

# Método para managers y designers: muestra las solicitudes o solicitudes de diseño sin asignar
  def filter_unassigned_requests(role = current_user.role.name)
    if role == 'manager' || role == 'director'
      requests = Request.where.not('status' => ['creada','expirada','cancelada'])
      assigned = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where("roles.name = ? OR roles.name = ?", "manager", "director")
    elsif role == 'designer'
      requests = DesignRequest.where.not('status' => ['concluida','expirada','cancelada'])
      assigned = DesignRequest.where.not('status' => ['concluida','expirada','cancelada']).joins(users: :role).where('roles.name' => 'designer')
    end
    unassigned = (requests - assigned)
    @unassigned = unassigned.sort_by{ |key| key["created_at"] }
    @unassigned
  end

# Este método sirve para que usuarios con roles distintos a Manager o Designer puedan ver el estatus
  def filter_supporters_view
    @supporters = Request.where.not('status' => ['creada','expirada','cancelada']).joins(users: :role).where("roles.name = ? OR roles.name = ?", "manager", "director").order(:created_at).order(:store_code)
    @supporters
  end

# Este método filtra las solicitudes autorizadas para que las vean los usuarios 'product-admin'
  def filter_confirmed_requests
    @confirmed = Request.where(status: 'autorizada')
  end

end
