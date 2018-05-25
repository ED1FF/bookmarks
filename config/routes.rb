Rails.application.routes.draw do
  resources :bookmarks
  root 'bookmarks#index'
  post '/friends_bookmarks', to: "bookmarks#friends_bookmarks"
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'friends_bookmarks' ,to: 'bookmarks#friends_bookmarks'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out', via: :all
end
