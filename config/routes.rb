Rails.application.routes.draw do
  get 'movielistconnectors/controller'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  resources :lists, except: [:edit, :update] do
    resources :movielistconnectors, only: [:new, :create]
  end
  resources :movielistconnectors, only: :destroy
  resources :movies, only: [:index, :show]
end
