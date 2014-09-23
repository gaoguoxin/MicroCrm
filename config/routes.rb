Rails.application.routes.draw do
  root 'welcome#index'
  get '/regist' => 'users#new'
  get '/login'  => 'sessions#new'
  delete '/logout' => 'sessions#destroy'


  namespace :admin do
    resources :users
    resources :orders
    resources :companies do 
      collection do 
        get 'search_manager'
        post 'update_info'
        get 'delete'
      end
    end
    resources :courses
  end

  namespace :manager do
     resources :orders
     resources :users
  end

  namespace :user do 
    resources :users do 
      collection do 
        post 'update_info'
        post 'update_pwd'
      end
    end
    resources :courses
    resources :feedbacks
  end

  resources :orders

  resources :courses

  resources :companies

  resources :users do 
    collection do 
      post  'check_exist'
    end
  end

  resources :sessions
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
    # namespace :admin do
    #   # Directs /admin/products/* to Admin::ProductsController
    #   # (app/controllers/admin/products_controller.rb)
    #   resources :products
    # end
end
