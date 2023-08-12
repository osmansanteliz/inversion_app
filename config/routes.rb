Rails.application.routes.draw do
  resources :investments, only: [:new, :create, :show]
  root to: 'investments#new'

  resources :investments, only: [:show] do
    member do
      get 'export_csv', to: 'investments#export_csv', as: 'export_csv'
      get 'export_json', to: 'investments#export_json', as: 'export_json'
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
