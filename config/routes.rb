require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  devise_for :users, controllers: { confirmations: 'confirmations', omniauth_callbacks: 'omniauth_callbacks' } do
    member do
      get :conrifm_email
    end
  end
  
  concern :commentable do
    resources :comments, shallow: true
  end
  concern :votable do
    resources :votes, only: [:create, :destroy]
  end
  resources :answers, concerns: [:votable, :commentable]
  
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true do
      member do
        post :mark_best
      end
    end

    resources :subscriptions , only: [:create, :destroy], shallow: true
  end
  resources :attachments, only: :destroy
  root to: "questions#index"

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :other_users, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:patch], :as => :finish_signup
  resources :searches , only: [:index]

end
