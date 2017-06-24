Rails.application.routes.draw do
  get 'stores/index'

  get 'stores/new'

  get 'stores/show'

  root 'pages#index'

  get 'billing_addresses/index'

  get 'billing_addresses/show'

  get 'requests/special'

  get 'requests/catalog'

  get 'requests/index'

  get 'requests/follow'

  get 'requests/assigned'

  get 'requests/unassigned'

  get 'requests/assigned_to_designer'

  get 'orders/special'

  get 'orders/catalog'

  get 'orders/index'

  get 'pages/index'

  get 'prospects/index'

  get 'filtered_requests/current_view'

  get 'filtered_requests/canceled_view'

  get 'filtered_requests/saved_view'

  get 'filtered_requests/assigned_view'

  get 'filtered_requests/unassigned_view'

  get 'filtered_requests/other_users_view'

  get 'filtered_requests/design_view'

  get 'filtered_requests/suporters_view'

  devise_for :users

  resources :users do
    resources :requests, controller: 'assigned_requests'
  end

# Estas rutas están perfectas y sí me sirven
  resources :prospects do
    resources :requests, :billing_addresses, :delivery_addresses
  end

  resources :stores do
    resources :requests, :billing_addresses, :delivery_addresses
  end

  resources :requests

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
