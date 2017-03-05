Rails.application.routes.draw do

  get '*path' => redirect { |_, request|
    "https://#{request.host_with_port.sub(/^www\./, '')}#{request.fullpath}" },
      constraints: lambda { |request| request.subdomain =~ /^www\./i }

  root to: redirect { |_, request| PainConConfig.root_domain },
       constraints: lambda { |request|
         request.subdomain =~ /^www$/i && request.query_parameters.blank?
       }

  root to: 'home#index', as: :dashboard

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'register', sign_out: 'logout'}, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
  }, skip: [:sessions]

  devise_scope :user do
    get 'login/(:id)', to: 'devise/sessions#new', as: :new_user_session

    get '/recover', to: 'devise/passwords#new'
    post 'user_session', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session

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
      get :email_password
      post :update_email_password
      get :timezone
      post :save_logo
      post :destroy_logo
      # put :update_flags
      # put :update_prefs
      delete :delete_account
    end

    collection do
      get :validation
    end
  end

  get '/user/:action/(:id)', controller: 'users'

  get '/auth/failure' => 'application#auth_failure', as: :auth_failure
  get '*path' => 'application#not_found', as: :not_found
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
