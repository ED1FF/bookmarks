Rails.application.routes.draw do
  resources :bookmarks
  root 'bookmarks#index'
  get 'auth/:provider/callback', to: 'sessions#create'

  match 'sign_out', to: 'sessions#destroy', as: 'sign_out', via: :all
end
