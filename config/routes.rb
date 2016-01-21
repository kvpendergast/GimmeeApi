Rails.application.routes.draw do
  resources :users, :products, :suppliers, :activities, :friendships, :productqueues
  
  resources :users do
    resources :channels
  end

  #Version 0
  get '/v0/products/:id', to: 'products#show'
  get '/v0/queues', to: 'queues#index'
  get '/v0/queues/:id', to: 'queues#show'
  get '/v0/users/:id/activities', to: 'activities#show'
  get '/v0/users/:id/productqueues', to: 'users#productqueue'
  get '/v0/queues/addproducts/:id', to: 'productqueues#addproductstoqueue'
  patch '/v0/friendships/accept/:id', to: 'friendships#accept_friend_request'
  patch '/v0/friendships/reject/:id', to: 'friendships#reject_friend_request'
  get '/v0/users/:id/friendships', to: 'users#friends'
  post '/v0/activities/share', to: 'activities#share'
  post '/v0/users', to: 'users#create'
  put '/v0/users/:id', to: 'users#update'
  get '/v0/parent_channels/users/:id', to: 'users#parent_channels'
  get '/v0/parent_channels/:parent_channel_id/users/:id', to: 'users#channels'
  get '/v0/channels/addproducts/:id', to: 'channels#addproducts'
  post '/v0/activity', to: 'activity#create'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'

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
