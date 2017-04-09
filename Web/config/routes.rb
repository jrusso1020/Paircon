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
      get :get_resource
      get :delete_resource
      get :get_event
      get :delete_event

      post :create_resource
      post :create_event

      delete :destroy_event
      delete :destroy_resource
    end
  end

  resources :conferences do
    member do
      get :invite
      get :delete

      post :process_invites
      post :destroy_cover
      post :destroy_logo
      post :save_cover
      post :save_logo
      post :attend_conference
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
      get :timezone
      get :become_organizer

      delete :delete_account

      post :update_email_password
      post :save_logo
      post :destroy_logo
      post :submit_url
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
