Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"
  
  # Trading routes
  resources :trades, except: [:edit, :update] do
    collection do
      get :stats
    end
  end
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  
  # Handle Chrome DevTools requests
  get '/.well-known/appspecific/com.chrome.devtools.json', to: proc { [404, {}, ['']] }
  
  # Handle Vite client requests (ignore silently)
  get '/@vite/client', to: proc { [404, {}, ['']] }
end
