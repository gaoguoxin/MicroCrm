Rails.application.routes.draw do
  root 'welcome#index'
  get '/regist' => 'users#new'
  get '/login'  => 'sessions#new'
  delete '/logout' => 'sessions#destroy'
  get '/fpwd'  => 'sessions#fpwd'
  get '/after_sign_in' => 'sessions#after_sign_in'

  namespace :admin do
    resources :users do 
      collection do 
        post 'check_exist'
        post 'update_info'
      end
    end
    resources :orders
    resources :companies do 
      collection do 
        get 'search_manager'
        post 'update_info'
        get 'delete'
        get 'search'
      end
    end
    resources :courses do 
      collection do 
        get 'match_manager'
        get 'match_student'
      end
    end
    resources :cards do
      collection do 
        get 'search_manager'
        post 'update_info'
        get 'delete'
        get 'search'
        get 'check_serial'
      end     
    end
  end

  namespace :manager do
    resources :orders do 
      collection do 
        post 'get_employee'
        get 'get_order_list'
        get 'check'
        get 'cancel'
      end
    end
    resources :users do
      collection do 
        get 'minfo'
        get 'delete'
        post 'update_pwd'
        post 'update_info'
      end
    end
    resources :feedbacks
  end

  namespace :user do 
    resources :users do 
      collection do 
        post 'update_info'
        post 'update_pwd'
      end
    end
    resources :orders do 
      member do 
        get 'cancel'
      end
    end 
    resources :feedbacks
  end

  resources :users do 
    collection do 
      post  'check_exist'
      post  'update_info'
    end
  end

  resources :sessions do 
    collection do
     get 'fpwd'
     post 'fpwd' 
     get 'after_sign_in'
    end
  end

  resources :category

  resources :orders

  resources :courses do 
    collection do 
      get 'search'
      get 'do_search'
    end
  end
  
  resources :feedbacks


  

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
