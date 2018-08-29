Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get 'home/index'
  root 'static_page#index'
  if Rails.env.development?
    apipie
  end
  
  resources :users, only: [:create, :update] do
    collection do
      post 'email_update'
    end
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      post 'auth/registration', to: 'users#registration'
      post 'auth/login', to: 'users#login'
      post 'auth(/:action)', controller: 'auth/social', action: :action, as: "auth"
      post 'auth/forgot', to: 'passwords#forgot'
      post 'profile/update', to: 'users#profile_update'
      get 'me', to: 'users#me'
      post 'charge', to: 'charges#new'
      resources :accounts, only: [:create]
      post :external, controller: :accounts
      get :update_account_status, controller: :accounts
      resources :users do
        get 'surveys/available', to: 'surveys#all_available_surveys_to_user'
        post 'save_survey_answers' => 'surveys#save_survey_answers'
        get 'surveys/my_responded_ideas', to: 'surveys#my_responded_ideas'
        resources :surveys do 
        get 'result', to: 'surveys#result'
        get 'test', to: 'surveys#test_result'
          resources :questions do 
            resources :solutions do
              resources :feedbacks
            end
          end
        end
      end
      # Stripe webhooks
      post '/hooks/stripe' => 'hooks#stripe'
    end
	end

  post 'passwords/forgot', to: 'passwords#forgot'
  post 'passwords/reset', to: 'passwords#reset'
  put 'passwords/update', to: 'passwords#update'
end
