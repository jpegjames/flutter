Rails.application.routes.draw do
  get 'demos/new', as: 'new_demo'
  post 'demos/create', as: 'demos'


  get 'login' => 'sessions#new', as: 'login'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  get 'register' => 'users#new', as: 'register'

  resources :users, except: [:index]
  resources :posts do
    post 'like' => 'posts#like', as: 'like'
  end


  match '/' => 'posts#index', via: :get, as: 'root'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
