Rails.application.routes.draw do
  devise_for :users
  
  concern :votable do
    resources :votes, only: [:create, :destroy]
  end
  # Только таким способом, мне удалось сделать одинаковую ссылку на удаление голоса для ответа и вопроса
  resources :answers, concerns: :votable
  
  resources :questions, concerns: :votable do
    resources :answers, shallow: true do
      member do
        post :mark_best
      end
    end
  end
  resources :attachments, only: :destroy
  root to: "questions#index"
end
