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

  get 'stores/download_products_example'

  get 'stores/download_prospects_example'

  get 'stores/upload_info'

  post 'stores/save_csv_files'

  get 'stores/show_settings/:id', to: 'stores#show_settings', as: 'store_settings'

  get 'stores/settings/:id', to: 'stores#settings', as: 'edit_store_settings'

  get 'products/catalogue'

  get 'products/special'

  get 'bills/download_pdf/:id', to: 'bills#download_pdf', as: 'download_pdf'

  get 'bills/download_xml/:id', to: 'bills#download_xml', as: 'download_xml'

  get 'bills/download_xml_receipt/:id', to: 'bills#download_xml_receipt', as: 'download_xml_receipt'

  get 'bills/select_info'

  post 'bills/select_info'

  get 'bills/select_data'

  get 'bills/select_tickets'

  get 'bills/select_orders'

  get 'bills/preview'

  post 'bills/preview'

  get 'bills/cfdi_process'

  get 'bills/global_preview'

  get 'bills/process_info'

  get 'bills/process_data'

  get 'bills/details/:bill', to: 'bills#details', as: 'details'

  get 'bills/details_global/:bill', to: 'bills#details_global', as: 'details_global'

  get 'bills/bill_doc_/:id', to: 'bills#bill_doc', as: 'bills_doc'

  get 'bills/doc/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#doc', as: 'bill_doc'

  get 'bills/global_doc/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#global_doc', as: 'bill_global_doc'

  get 'bills/cfdi/:prospect/:tickets/:cfdi_use/:type_of_bill', to: 'bills#cfdi', as: 'bill_cfdi'

  get 'bills/form'

  get 'bills/billed_tickets'

  get 'bills/select_bills'

  get 'bills/modify'

  get 'bills/payment/:bill', to: 'bills#payment', as: 'payment'

  get 'bills/credit_note/:bill', to: 'bills#credit_note', as: 'credit_note'

  get 'bills/credit_note_global/:bill', to: 'bills#credit_note_global', as: 'credit_note_global'

  get 'bills/generate_credit_note'

  get 'bills/generate_debit_note'

  get 'bills/generate_devolution'

  get 'bills/generate_payment'

  get 'bills/generate_advance_e'

  get 'bills/generate_advance_i'

  get 'bills/debit_note/:bill', to: 'bills#debit_note', as: 'debit_note'

  get 'bills/devolution/:bill', to: 'bills#devolution', as: 'devolution'

  get 'bills/devolution_global/:bill', to: 'bills#devolution_global', as: 'devolution_global'

  get 'bills/advance_e', as: 'advance_e'

  get 'bills/advance_i', as: 'advance_i'

  get 'bills/modify/:bill', to: 'bills#modify', as: 'modify_bill'

  get 'bills/ticket_details/:id', to: 'bills#ticket_details', as: 'ticket_details'

  get 'bills/global_form'

  get 'inventories/index'

  get 'inventories/order_suggestions'

  get 'tickets/index'

  get 'orders/_product_details/:product', to: 'orders#product_details', as: 'product_details'

  get 'orders/delete_product_from_order/:id', to: 'orders#delete_product_from_order', as: 'delete_product_from_order'

  get 'orders/delete_order/:id', to: 'orders#delete_order', as: 'delete_order'

  get 'tickets/sales/:store/:year/:month', to: 'tickets#sales', as: 'sales'

  get 'bills/issued/:store/:year/:month', to: 'bills#issued', as: 'bills_issued'

  get 'tickets/sales_summary'

  get 'tikets/process_incomming_data'

  devise_for :users

  scope "/admin" do
    resources :users, controller: 'admin_users'
  end

  resources :delivery_addresses

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

  post '/api/get_all_products',    to: 'api#get_all_products'

  get 'warehouse/new_own_entry'

  get 'warehouse/remove_inventory'

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

  get 'warehouse/pending_products/:id', to: 'warehouse#pending_products', as: 'warehouse_pending_products'

  patch 'warehouse/assign_warehouse_staff/:id', to: 'warehouse#assign_warehouse_staff', as: 'assign_warehouse_staff', controller: 'orders'

  get 'warehouse/orders_products/:id', to: 'warehouse#orders_products', as: 'warehouse_order_products'

  patch 'warehouse/form_for_movement/:id', to: 'warehouse#form_for_movement', as: 'form_for_movement', controller: 'warehouse'

  patch 'warehouse/assign_warehouse_admin/:id', to: 'warehouse#assign_warehouse_admin', as: 'assign_warehouse_admin', controller: 'orders'

  get 'warehouse/pending_orders'

  get 'warehouse/prepare_order/:id', to: 'warehouse#prepare_order', as: 'warehouse_prepare_order'

  patch 'orders/change_delivery_address/:id', to: 'orders#change_delivery_address', as: 'change_delivery_address'

  get 'orders/get/:product', to: 'orders#get_product', as: 'orders_get_product'

  post 'orders/save_products/:store', to: 'orders#save_products', as: 'orders_save_product'

  get 'orders/show/:ids', to: 'orders#show', as: 'orders_show'

  get 'orders/show_for_store/:id', to: 'orders#show_for_store', as: 'orders_show_for_store'

  post 'orders/confirm/:ids', to: 'orders#confirm', as: 'orders_confirm'

  get 'orders/history'

  post 'pos/received_data', to: 'pos#received_data', as: 'received_data'


  # Agregar la ruta para descargar los archivos, el link para descargarlos y el link en el navbar
  # Agregar un proceso para crear un archivo de productos csv en las carpetas de stores
  # con nuevos códigos cada que se cree un nuevo producto de tienda (solo agregar renglón
  # para su tienda) o de corporativo
  # Links dinámicos para actualizar
end
