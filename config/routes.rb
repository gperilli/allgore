Rails.application.routes.draw do
  get 'bookmarks/controller'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'movies#index'
  resources :lists, except: [:edit, :update] do
    resources :bookmarks, only: [:new, :create]
  end
  resources :bookmarks, only: :destroy
  resources :movies, only: [:index, :show]
end
