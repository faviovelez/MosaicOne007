Rails.application.routes.draw do

  root 'pages#index'

  get 'pages/utilerias', defaults: { format: 'xml' }

  get 'movements/index'

  get 'movements/edit'

  get 'bill_receiveds/new'

  get 'bill_receiveds/get_document/:id', to: 'bill_receiveds#get_document', as: 'get_document'

  get 'bill_receiveds/edit/:id', to: 'bill_receiveds#edit', as: 'bill_receiveds_edit'

  get 'bill_receiveds/show/:id', to: 'bill_receiveds#show', as: 'bill_receiveds_show'

  get 'bill_receiveds/index'

  get 'bill_receiveds/history'

  post 'bill_receiveds/create'

  post 'bill_receiveds/attach_payment'

  post 'bill_receiveds/update'

  put 'bill_receiveds/update'

  patch 'bill_receiveds/update'

  get 'prospects/sales_view/:id', to: 'prospects#sales_view', as: 'prospects_sales_view'

  get 'delivery_services/filter_for_viewers'

  get 'delivery_services/select_report'

  get 'delivery_services/delivery_services_database'

  get 'delivery_services/delivery_services_report'

  get 'delivery_services/report_type'

  get 'delivery_services/cost_save_view'

  post 'delivery_services/save_cost'

  get 'delivery_services/show_report/:id', to: 'delivery_services#show_report', as: 'delivery_services_show_report'

  get 'delivery_services/show_database/:id', to: 'delivery_services#show_database', as: 'delivery_services_show_database'

  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  get 'filtered_requests/current_view'

  get 'filtered_requests/delivered_view'

  get 'filtered_requests/inactive_view'

  get 'filtered_requests/saved_view'

  get 'filtered_requests/assigned_view'

  get 'filtered_requests/unassigned_view'

  get 'filtered_requests/other_users_view'

  get 'filtered_requests/supporters_view'

  get 'filtered_requests/product_view'

  get 'requests/send_estimate_mail/:id', to: 'requests#send_estimate_mail', as: 'send_estimate_mail'

  get 'requests/send_authorisation_mail/:id', to: 'requests#send_authorisation_mail', as: 'send_authorisation_mail'

  get 'stores/download_products_example'

  get 'stores/download_prospects_example'

  get 'stores/upload_info'

  post 'stores/save_csv_files'

  get 'stores/show_settings/:id', to: 'stores#show_settings', as: 'store_settings'

  get 'stores/settings/:id', to: 'stores#settings', as: 'edit_store_settings'

  get 'products/massive_price_change'

  post 'products/change_billing_address'

  post 'products/change_price_process'

  get 'products/catalogue'

  get 'products/special'

  get 'tickets/prospect_view/:id', to: 'tickets#prospect_view', as: 'tickets_prospect_view'

  get 'tickets/tickets_closure_day_pdf'

  get 'tickets/no_payment'

  get 'tickets/saved'

  get 'tickets/ticket_sales'

  get 'tickets/product_sales'

  post 'bills/cancel_pay_bill'

  get 'bills/pending'

  post 'bills/select_pay_bills'

  post 'bills/pay_cfdi_process'

  get 'bills/partially_payed_bills'

  get 'bills/partially_payed_bills_with_pay_bill'

  get 'bills/payment_bill_preview'

  get 'bills/get_document/:id', to: 'bills#get_document', as: 'get_document_bill'

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

  post 'bills/confirm_payments'

  get 'bills/cancelled'

  get 'bills/cfdi_process'

  post 'bills/cfdi_process'

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

  get 'bills/ticket_details/:id', to: 'bills#ticket_details', as: 'bills_ticket_details'

  get 'bills/global_form'

  get 'inventories/index_with_data'

  get 'inventories/index'

  get 'inventories/order_suggestions'

  get 'inventories/show_product_movements'

  get 'inventories/select_report'

  get 'inventories/get_report'

  get 'inventories/select_inventory_report'

  get 'inventories/inventories_report'

  get 'tickets/index'

  get 'tickets/details/:id', to: 'tickets#details', as: 'ticket_details'

  get 'tickets/select_day'

  get 'tickets/get_date'

  get 'tickets/cancelled_tickets'

  get 'tickets/closure_day/:date', to: 'tickets#closure_day', as: 'tickets_closure_day'

  get 'tickets/closure_day_detailed/:date', to: 'tickets#closure_day_detailed', as: 'tickets_closure_day_detailed'

  get 'tickets/sales/:store/:year/:month', to: 'tickets#sales', as: 'sales'

  get 'bills/issued/:store/:year/:month', to: 'bills#issued', as: 'bills_issued'

  get 'tickets/sales_summary'

  get 'tikets/process_incomming_data'

  get 'products/show_product_csv'

  get 'products/show_product_cost_for_stores'

  get 'products/show_product_cost_for_franchises'

  get 'products/show_product_cost_for_corporate'

  get 'orders/bill_received_extended/:ids/:type/:initial_date/:final_date/', to: 'orders#bill_received_extended', as: 'orders_bill_received_extended'

  get 'orders/bill_received_extended_total/:initial_date/:final_date/:bills/:bill_receiveds', to: 'orders#bill_received_extended_total', as: 'orders_bill_received_extended_total'

  get 'orders/bill_received_summary'

  get 'orders/store_sales_comparision'

  get 'orders/sales_by_stores_summary/:date_selected/:client_list', to: 'orders#sales_by_stores_summary', as: 'orders_sales_by_stores_summary'

  get 'orders/edit_discount/:id', to: 'orders#edit_discount', as: 'edit_discount'

  post 'orders/update_discount'

  post 'orders/confirm_received'

  get 'orders/cancelled'

  get 'orders/orders_for_viewers'

  get 'orders/index_for_viewers'

  get 'orders/history_for_viewers'

  get 'orders/pr_for_viewers/:id', to: 'orders#pr_for_viewers', as: 'orders_pr_for_viewers'

  get 'orders/filter_for_viewers'

  get 'orders/_product_details/:product', to: 'orders#product_details', as: 'product_details'

  get 'orders/delete_product_from_order/:id', to: 'orders#delete_product_from_order', as: 'delete_product_from_order'

  get 'orders/delete_order/:id', to: 'orders#delete_order', as: 'delete_order'

  patch 'orders/change_delivery_address/:id', to: 'orders#change_delivery_address', as: 'change_delivery_address'

  get 'orders/get/:product', to: 'orders#get_product', as: 'orders_get_product'

  post 'orders/save_products/:store_id', to: 'orders#save_products', as: 'orders_save_product'

  post 'orders/save_products_for_prospects/:prospect_id', to: 'orders#save_products_for_prospects', as: 'orders_save_products_for_prospects'

  get 'orders/new_order_for_prospects/:prospect_id', to: 'orders#new_order_for_prospects', as: 'orders_new_order_for_prospects'

  get 'orders/show/:ids', to: 'orders#show', as: 'orders_show'

  get 'orders/show_for_store/:id', to: 'orders#show_for_store', as: 'orders_show_for_store'

  get 'orders/show_for_differences/:id', to: 'orders#show_for_differences', as: 'orders_show_for_differences'

  post 'orders/confirm/:ids', to: 'orders#confirm', as: 'orders_confirm'

  get 'orders/history'

  get 'orders/for_delivery'

  get 'orders/differences'

  get 'orders/differences_history'

  post 'orders/solve_differences'

  get 'orders/new_corporate/:store_id', to: 'orders#new_corporate', as: 'orders_new_corporate'

  get 'orders/payment_report'

  get 'orders/process_report'

  get 'orders/select_report'

  get 'orders/show_sales'

  get 'orders/billing_report'

  get 'orders/collection_report'

  get 'orders/stores_by_month_and_year'

  get 'requests/authorisation_doc/:id', to: 'requests#authorisation_doc', as: 'request_authorisation'

  get 'requests/authorisation_page/:id', to: 'requests#authorisation_page'

  get 'requests/authorisation_mail_doc/:id', to: 'requests#authorisation_mail_doc', as: 'request_authorisation_mail'

  get 'requests/estimate_doc/:id', to: 'requests#estimate_doc', as: 'request_estimate'

  get 'requests/estimate_page/:id', to: 'requests#estimate_page'

  get 'requests/estimate_mail_doc/:id', to: 'requests#estimate_mail_doc', as: 'request_estimate_mail'

  get 'requests/confirm/:id', to: 'requests#confirm', as: 'confirm_requests'

  get 'requests/confirm_view/:id', to: 'requests#confirm_view', as: 'confirm_view_requests'

  get 'requests/price/:id', to: 'requests#price', as: 'requests_price'

  get 'requests/manager/:id', to: 'requests#manager', as: 'manager_requests'

  get 'requests/manager_view/:id', to: 'requests#manager_view', as: 'manager_view_requests'

  get 'requests/manager_after/:id', to: 'requests#manager_after', as: 'manager_after'

  get 'design_requests/designer/:id', to: 'design_requests#designer_view', as: 'designer_view_requests'

  get 'design_requests/designer/:id', to: 'design_requests#designer', as: 'designer_requests'

  get 'delivery_addresses/other_addresses_new/:store_id', to: 'delivery_addresses#other_addresses_new', as: 'other_addresses'

  get 'delivery_addresses/other_addresses_update/:store_id', to: 'delivery_addresses#other_addresses_update', as: 'other_addresses_update'

  post 'delivery_addresses/other_deliveries'

  patch 'delivery_addresses/other_deliveries_update'

  put 'delivery_addresses/other_deliveries_update'

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
    resources :billing_addresses, :delivery_addresses, :requests, :orders
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

  resources :services

  post '/api/get_all_products', to: 'api#get_all_products'

  get '/api/get_all_products_for_bill', to: 'api#get_all_products_for_bill'

  get '/api/get_just_products', to: 'api#get_just_products'

  get '/api/get_info_from_product/:id/:store_id', to: 'api#get_info_from_product', as: "get_info_from_product"

  get '/api/get_info_from_product_store/:id/:store_id/:this_store', to: 'api#get_info_from_product', as: "get_info_from_product_store"

  get '/api/get_info_from_product_with_prospect/:id/:store_id/:prospect_id', to: 'api#get_info_from_product_with_prospect', as: "get_info_from_product_with_prospect"

  get '/api/get_prospects_for_store', to: 'api#get_prospects_for_store'

  get 'api/select_prospects_info'

  get '/api/get_all_suppliers_for_corporate', to: 'api#get_all_suppliers_for_corporate'

  get 'warehouse/select_product'

  post 'warehouse/product_selected'

  get 'warehouse/product_requests_by_product'

  post 'warehouse/complete_preparation'

  get 'warehouse/new_own_entry'

  get 'warehouse/sales_for_billing'

  get 'warehouse/remove_inventory'

  post 'warehouse/remove_product', to: 'warehouse#remove_product', as: 'warehouse_remove_product'

  get 'warehouse/show_removeds/:entry_codes', to: 'warehouse#show_removeds', as: 'warehouse_show_removeds'

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

  get 'warehouse/ready_orders'

  get 'warehouse/waiting_products/:id', to: 'warehouse#waiting_products', as: 'warehouse_waiting_products'

  get 'warehouse/pending_products/:id', to: 'warehouse#pending_products', as: 'warehouse_pending_products'

  patch 'warehouse/assign_warehouse_staff/:id', to: 'warehouse#assign_warehouse_staff', as: 'assign_warehouse_staff', controller: 'orders'

  get 'warehouse/orders_products/:id', to: 'warehouse#orders_products', as: 'warehouse_order_products'

  patch 'warehouse/form_for_movement/:id', to: 'warehouse#form_for_movement', as: 'form_for_movement', controller: 'warehouse'

  patch 'warehouse/assign_warehouse_admin/:id', to: 'warehouse#assign_warehouse_admin', as: 'assign_warehouse_admin', controller: 'orders'

  get 'warehouse/pending_orders'

  get 'warehouse/show_order/:id', to: 'warehouse#show_order', as: 'warehouse_show_order'

  get 'warehouse/prepare_order/:id', to: 'warehouse#prepare_order', as: 'warehouse_prepare_order'

  get 'warehouse/show_prepared_order/:id', to: 'warehouse#show_prepared_order', as: 'warehouse_show_prepared_order'

  post 'warehouse/assign_driver'

  resources :drivers

  post 'pos/received_data', to: 'pos#received_data', as: 'received_data'

  require 'sidekiq/web'
  match "queue-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 100 ? "OK" : "UHOH" ]] }, via: :get
  authenticate :user, lambda { |u| u.role.name == 'platform-admin' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Agregar la ruta para descargar los archivos, el link para descargarlos y el link en el navbar
  # Agregar un proceso para crear un archivo de productos csv en las carpetas de stores
  # con nuevos códigos cada que se cree un nuevo producto de tienda (solo agregar renglón
  # para su tienda) o de corporativo
  # Links dinámicos para actualizar
end
