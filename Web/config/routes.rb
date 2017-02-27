Rails.application.routes.draw do

  get '*path' => redirect { |_, request|
    "https://#{request.host_with_port.sub(/^www\./, '')}#{request.fullpath}" },
      constraints: lambda { |request| request.subdomain =~ /^www\./i }

  root to: redirect { |_, request| PainConConfig.root_domain },
       constraints: lambda { |request|
         request.subdomain =~ /^www$/i && request.query_parameters.blank?
       }

  devise_for :user, path: '', path_names: { sign_in: 'login', sign_up: 'register', sign_out: 'logout'}, controllers: {
      omniauth_callbacks: 'user/omniauth_callback',
      registrations: 'user/registration'
  }, skip: [:sessions]

  devise_scope :user do
    root to: 'devise/sessions#new', as: :new_user_session

    post 'user_session', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :home, path: '' do
    collection do
      get :home
      get :about
      get :features
    end
  end

  get '/user/:action/(:id)', controller: 'users'

  get '/auth/failure' => 'application#auth_failure', as: :auth_failure
  get '*path' => 'application#not_found', as: :not_found
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
