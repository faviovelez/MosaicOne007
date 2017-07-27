Rails.application.routes.draw do

  root 'pages#index'

  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  get 'pages/index'

  get 'filtered_requests/current_view'

  get 'filtered_requests/inactive_view'

  get 'filtered_requests/saved_view'

  get 'filtered_requests/assigned_view'

  get 'filtered_requests/unassigned_view'

  get 'filtered_requests/other_users_view'

  get 'filtered_requests/supporters_view'

  get 'filtered_requests/product_view'

  devise_for :users

  resources :products

  resources :users do
    resources :requests, controller: 'assigned_requests'
  end

  resources :prospects do
    resources :billing_addresses, :delivery_addresses, :requests
  end

  resources :stores do
    resources :prospects, :requests, :billing_addresses, :delivery_addresses, :orders
  end

  resources :requests do
    resources :design_requests, controller: 'design_requests'
    resources :products
  end

  resources :design_requests

  resources :billing_addresses

  resources :documents

  get 'requests/confirm/:id', to: 'requests#confirm', as: 'confirm_requests'

  get 'requests/confirm_view/:id', to: 'requests#confirm_view', as: 'confirm_view_requests'

  get 'requests/price/:id', to: 'requests#price', as: 'requests_price'

  get 'requests/manager/:id', to: 'requests#manager', as: 'manager_requests'

  get 'requests/manager_view/:id', to: 'requests#manager_view', as: 'manager_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer_view', as: 'designer_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer', as: 'designer_requests'

  get 'warehouse/new'

  get 'warehouse/edit'

  get 'warehouse/show'

end
