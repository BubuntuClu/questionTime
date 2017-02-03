Rails.application.routes.draw do
  devise_for :users

  resources :answers 
  
  concern :votable do
    resources :votes, only: [:create, :destroy], shallow: true
  end
  
  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :mark_best
      end
    end
  end
  resources :attachments, only: :destroy
  root to: "questions#index"
end
