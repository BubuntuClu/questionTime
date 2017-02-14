Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } do
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
  end
  resources :attachments, only: :destroy
  root to: "questions#index"

  mount ActionCable.server => '/cable'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
end
