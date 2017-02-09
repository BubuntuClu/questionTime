Rails.application.routes.draw do
  devise_for :users
  
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
end
