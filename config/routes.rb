Rails.application.routes.draw do

  get 'movements/index'

  get 'movements/edit'

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

  scope "/admin" do
    resources :users, controller: 'admin_users'
  end

  resources :delivery_addresses

  get 'products/catalogue'

  get 'products/special'

  resources :products do
    get 'images', to: 'products#images', as: 'product_images'
    resources :images, controller: 'products'
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

  get 'warehouse/new_own_entry'

  get 'warehouse/new_supplier_entry'

  get 'warehouse/edit/:id', to: 'warehouse#edit', as: 'warehouse_edit_entry'

  get 'warehouse/get/:product', to: 'warehouse#get_product', as: 'warehouse_get_product'

  get 'warehouse/show'

  get 'warehouse/index'

  get 'warehouse/orders'

  get 'warehouse/orders_products/:id', to: 'warehouse#orders_products', as: 'warehouse_order_products'

  patch 'warehouse/form_for_movement/:id', to: 'warehouse#form_for_movement', as: 'form_for_movement', controller: 'warehouse'

end
