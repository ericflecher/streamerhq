Streamerhq::Application.routes.draw do
  
  resources :features
  resources :docs
  
  match '/feature/new/:doc_id' => 'features#new', :as => 'new'
  match '/feature/new/:feature_id' => 'features#new', :as => 'new'
  match '/follow/:doc_id/:follow_code' => 'docs#show', :as => 'follow'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end