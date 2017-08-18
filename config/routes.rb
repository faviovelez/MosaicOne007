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

  resources :suppliers do
    resources :delivery_addresses
  end

  resources :business_groups do
    resources :suppliers, :prospects
  end

  resources :prospects do
    resources :billing_addresses, :delivery_addresses, :requests
  end

  resources :stores do
    resources :prospects, :requests, :delivery_addresses, :orders, :warehouses
  end

  resources :requests do
    resources :design_requests, controller: 'design_requests'
    resources :products
  end

  resources :design_requests

  resources :billing_addresses

  resources :documents

  resources :business_units do
    resources :warehouses, :billing_addresses
  end

  resources :warehouses do
    resources :delivery_addresses
  end

  get 'requests/confirm/:id', to: 'requests#confirm', as: 'confirm_requests'

  get 'requests/confirm_view/:id', to: 'requests#confirm_view', as: 'confirm_view_requests'

  get 'requests/price/:id', to: 'requests#price', as: 'requests_price'

  get 'requests/manager/:id', to: 'requests#manager', as: 'manager_requests'

  get 'requests/manager_view/:id', to: 'requests#manager_view', as: 'manager_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer_view', as: 'designer_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer', as: 'designer_requests'

  get 'warehouse/new_own_entry'

  post 'warehouse/confirm/:entry_codes', to: 'warehouse#confirm', as: 'warehouse_confirm'

  get 'warehouse/new_supplier_entry'

  get 'warehouse/edit/:id/', to: 'warehouse#edit', as: 'warehouse_edit_entry'

  delete 'warehouse/delete/:id/:entry_codes', to: 'warehouse#destroy', as: 'warehouse_delete_entry'

  get 'warehouse/get/:product', to: 'warehouse#get_product', as: 'warehouse_get_product'

  get 'warehouse/show/:entry_codes', to: 'warehouse#show', as: 'warehouse_show'

  get 'warehouse/index'

  post 'warehouse/save_own_product'

  post 'warehouse/save_supplier_product'

  get 'warehouse/orders'

  get 'warehouse/orders_products/:id', to: 'warehouse#orders_products', as: 'warehouse_order_products'

  patch 'warehouse/form_for_movement/:id', to: 'warehouse#form_for_movement', as: 'form_for_movement', controller: 'warehouse'

  get 'orders/get/:product', to: 'orders#get_product', as: 'orders_get_product'

  post 'orders/save_products/:store', to: 'orders#save_products', as: 'orders_save_product'

  get 'orders/show/:id', to: 'orders#show', as: 'orders_show'

  post 'orders/confirm/:id', to: 'orders#confirm', as: 'orders_confirm'

  get 'orders/history'

  get 'stores/show_settings/:id', to: 'stores#show_settings', as: 'store_inventory_settings'

  get 'stores/inventory_settings/:id', to: 'stores#inventory_settings', as: 'edit_store_inventory_settings'

end
