Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :answers 
  
  resources :questions do
    resources :votes, only: [:create], shallow: true
    resources :answers, shallow: true do
      resources :votes, only: [:create], shallow: true
      member do
        post :mark_best
      end
    end
  end
  resources :attachments, only: :destroy
  resources :votes, only: [:destroy]
  root to: "questions#index"
end
