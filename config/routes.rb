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

  resources :discount_rules

  resources :business_units do
    resources :warehouses, :billing_addresses
  end

  resources :warehouses do
    resources :delivery_addresses
  end

  get 'inventories/index'

  get 'inventories/order_suggestions'

  get 'bills/select_info'

  post 'bills/select_info'

  get 'bills/select_data'

  get 'bills/select_tickets'

  get 'bills/select_orders'

  get 'bills/bill_doc_/:id', to: 'bills#bill_doc', as: 'bills_doc'

  get 'bills/doc/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#doc', as: 'bill_doc'

  get 'bills/global_doc/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#global_doc', as: 'bill_global_doc'

  get 'bills/preview/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#preview', as: 'bills_preview'

  get 'bills/global_preview/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#global_preview', as: 'bills_global_preview'

  post 'bills/process_info'

  get 'bills/process_data'

  get 'bills/cfdi/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#cfdi', as: 'bill_cfdi'

  resources :bills

  get 'requests/authorisation_doc/:id', to: 'requests#authorisation_doc', as: 'request_authorisation'

  get 'requests/authorisation_page/:id', to: 'requests#authorisation_page'

  get 'requests/estimate_doc/:id', to: 'requests#estimate_doc', as: 'request_estimate'

  get 'requests/estimate_page/:id', to: 'requests#estimate_page'

  get 'requests/confirm/:id', to: 'requests#confirm', as: 'confirm_requests'

  get 'requests/confirm_view/:id', to: 'requests#confirm_view', as: 'confirm_view_requests'

  get 'requests/price/:id', to: 'requests#price', as: 'requests_price'

  get 'requests/manager/:id', to: 'requests#manager', as: 'manager_requests'

  get 'requests/manager_view/:id', to: 'requests#manager_view', as: 'manager_view_requests'

  get 'requests/manager_after/:id', to: 'requests#manager_after', as: 'manager_after'

  get 'design_requests/designer/:id', to: 'design_requests#designer_view', as: 'designer_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer', as: 'designer_requests'

  get 'warehouse/new_own_entry'

  get 'warehouse/remove_inventory'
  post '/api/get_all_products',    to: 'api#get_all_products'
  post 'warehouse/remove_product', to: 'warehouse#remove_product', as: 'warehouse_remove_product'
  get 'warehouse/show_remove', to: 'warehouse#show_removeds', as: 'warehouse_show_remove'

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

  get 'warehouse/unassigned_orders'

  get 'warehouse/waiting_orders'

  get 'warehouse/waiting_products/:id', to: 'warehouse#waiting_products', as: 'warehouse_waiting_products'

  patch 'orders/change_delivery_address/:id', to: 'orders#change_delivery_address', as: 'change_delivery_address'

  get 'warehouse/pending_products/:id', to: 'warehouse#pending_products', as: 'warehouse_pending_products'

  patch 'warehouse/assign_warehouse_staff/:id', to: 'warehouse#assign_warehouse_staff', as: 'assign_warehouse_staff', controller: 'orders'

  get 'warehouse/orders_products/:id', to: 'warehouse#orders_products', as: 'warehouse_order_products'

  patch 'warehouse/form_for_movement/:id', to: 'warehouse#form_for_movement', as: 'form_for_movement', controller: 'warehouse'

  patch 'warehouse/assign_warehouse_admin/:id', to: 'warehouse#assign_warehouse_admin', as: 'assign_warehouse_admin', controller: 'orders'

  get 'warehouse/pending_orders'

  get 'warehouse/prepare_order/:id', to: 'warehouse#prepare_order', as: 'warehouse_prepare_order'

  get 'orders/get/:product', to: 'orders#get_product', as: 'orders_get_product'

  post 'orders/save_products/:store', to: 'orders#save_products', as: 'orders_save_product'

  get 'orders/show/:ids', to: 'orders#show', as: 'orders_show'

  get 'orders/show_for_store/:id', to: 'orders#show_for_store', as: 'orders_show_for_store'

  post 'orders/confirm/:ids', to: 'orders#confirm', as: 'orders_confirm'

  get 'orders/history'

  get 'stores/show_settings/:id', to: 'stores#show_settings', as: 'store_settings'

  get 'stores/settings/:id', to: 'stores#settings', as: 'edit_store_settings'

end
