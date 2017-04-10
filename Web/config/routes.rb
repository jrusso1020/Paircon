Rails.application.routes.draw do

  get '*path' => redirect { |_, request|
    "https://#{request.host_with_port.sub(/^www\./, '')}#{request.fullpath}" },
      constraints: lambda { |request| request.subdomain =~ /^www\./i }

  root to: redirect { |_, request| PainConConfig.root_domain },
       constraints: lambda { |request|
         request.subdomain =~ /^www$/i && request.query_parameters.blank?
       }

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'register', sign_out: 'logout'}, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
  }, skip: [:sessions]

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :dashboard
    end

    unauthenticated do
      root 'devise/sessions#new', as: :new_user_session
    end

    get '/recover', to: 'devise/passwords#new'
    post 'user_session', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session

  end

  mount PdfjsViewer::Rails::Engine => "/pdf", as: 'pdf'

  resources :posts do
    member do
      get :delete
    end
  end

  resources :schedules do
    collection do
      get :get_rooms
      get :get_resources
      get :get_events

      get :new_resource
      post :create_resource
      get :delete_resource
      delete :destroy_resource

      get :new_event
      post :create_event
      get :delete_event
      delete :destroy_event

      get :edit_event
      post :update_event
    end
  end

  resources :conferences do
    member do
      get :delete
      post :destroy_cover
      post :destroy_logo
      post :save_cover
      post :save_logo
      post :attend_conference

      get :home
      get :about
      get :recommendations
      get :posts
      get :schedule
    end
  end

  resources :notifications do
    collection do
      post :read_notification
    end
  end

  resources :home, path: '' do
    collection do
      get :about
      get :features
      get :terms
      get :privacy_policy
    end
  end
  resources :users, except: [:index] do
    member do
      get :delete
      get :change_active_status
      get :password_reset
      post :update_email_password
      get :timezone
      post :save_logo
      post :destroy_logo
      delete :delete_account
      post :submit_url
      get :become_organizer
      post :request_organizer
    end

    collection do
      get :validation
    end
  end

  get '/user/:action/(:id)', controller: 'users'
  get '/auth/failure' => 'application#auth_failure', as: :auth_failure
  get '*path' => 'application#not_found', as: :not_found

end
