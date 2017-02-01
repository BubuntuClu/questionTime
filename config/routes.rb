Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :answers 
  resources :questions do
    resources :answers, shallow: true do
      member do
        post :mark_best
      end
    end
  end
  resources :attachments, only: :destroy
  resources :votes, only: [:create, :destroy]
  root to: "questions#index"
end
