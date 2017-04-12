Rails.application.routes.draw do

  get 'errors/not_found'

  get 'errors/internal_server_error'

  get '*path' => redirect { |_, request|
    "https://#{request.host_with_port.sub(/^www\./, '')}#{request.fullpath}" },
      constraints: lambda { |request| request.subdomain =~ /^www\./i }

  root to: redirect { |_, request| PainConConfig.root_domain },
       constraints: lambda { |request|
         request.subdomain =~ /^www$/i && request.query_parameters.blank?
       }

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'register', sign_out: 'logout'}, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations',
      sessions: 'users/sessions'
  }

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :dashboard
    end

    unauthenticated do
      root 'users/sessions#new'
    end

    get '/recover', to: 'devise/passwords#new'
    post 'user_session', to: 'users/sessions#create'
    delete 'logout', to: 'users/sessions#destroy'

  end

  match '/404', :to => 'errors#not_found', :via => :all
  match '/403', :to => 'errors#unauthorized_access', :via => :all
  match '/500', :to => 'errors#internal_server_error', :via => :all

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
      get :get_events_user
      get :delete_resource
      get :new_resource
      get :new_event
      get :delete_event
      get :edit_event

      post :create_resource
      post :create_event
      post :create_resource
      post :create_event
      post :update_event

      delete :destroy_event
      delete :destroy_resource
    end
  end

  resources :conferences do
    member do
      get :invite
      get :delete

      post :create_invites
      post :destroy_cover
      post :destroy_logo
      post :save_cover
      post :save_logo
      post :attend_conference

      get :home
      get :about_panel
      get :recommendations
      get :posts
      get :schedule
      get :papers
    end
  end

  resources :notifications do
    collection do
      post :read_notification
    end
  end

  resources :home, path: '' do
    collection do
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
      get :pending_organizers

      delete :delete_account

      post :update_email_password
      post :save_logo
      post :destroy_logo
      post :submit_url
      post :request_organizer
      post :approve_organizer
    end

    collection do
      get :validation
    end
  end

  get '/user/:action/(:id)', controller: 'users'
  get '/auth/failure' => 'application#auth_failure', as: :auth_failure
  get '*path' => 'application#not_found', as: :not_found

end
