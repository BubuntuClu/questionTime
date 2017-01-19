Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :answers do
    collection do
      get :mark_best
    end
  end
  resources :questions do
    resources :answers
  end

  root to: "questions#index"
end
