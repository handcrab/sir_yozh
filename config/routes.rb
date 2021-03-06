Rails.application.routes.draw do
  get 'posts/index'

  devise_for :users

  get 'channels/:id/posts', to: 'posts#channel_index', as: 'channel_posts'
  get 'channels/personal' => 'channels#personal'
  resources :channels do
    patch 'toggle_public', on: :member
    # get 'posts', on: :member, to: 'posts#channel_index', as: 'channel_posts'
  end

  authenticated :user do
    root to: 'channels#personal', as: :authenticated_root
  end
  root 'channels#index'

  get 'tags/:tag', to: 'channels#index', as: :tag  
  get 'tags/:tag/posts', to: 'posts#tagged', as: :tag_posts
  
  get 'posts' => 'posts#index'

  match "/delayed_job" => DelayedJobWeb, anchor: false, via: [:get, :post]
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
