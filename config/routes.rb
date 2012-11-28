Streamerhq::Application.routes.draw do
  
  resources :features
  resources :docs
  
  match '/feature/new/:doc_id' => 'features#new', :as => 'new'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end