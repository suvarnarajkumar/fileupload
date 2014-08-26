Rails.application.routes.draw do
  resources :datafiles
  
  root "datafiles#index"
  
  match "/sendmail" => "datafiles#sendmail", via: [:get, :post]
  
  match "/adminlogin" => "datafiles#adminlogin", via: [:get, :post]
  
  match "/adminlogout" => "datafiles#adminlogout", via: [:get, :post]
  
  match "/usersignup" => "datafiles#usersignup", via: [:get, :post]
  
  get "/index_content" => "datafiles#index_content"
  
  post "/update_user" => "datafiles#update_user"
  
  post "/delete_user" => "datafiles#delete_user"
  
  post "/usernamecheck" => "datafiles#usernamecheck"
  
  post "/emailnamecheck" => "datafiles#emailnamecheck"
  
  post "/pwd_decrpt" => "datafiles#pwd_decrpt"
  
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
