Streamerhq::Application.routes.draw do
  
  resources :features
  resources :docs
  
  match '/feature/new/:doc_id' => 'features#new', :as => 'new'
  match '/feature/new/:feature_id' => 'features#new', :as => 'new'
  match '/follow/:doc_id/:follow_code' => 'docs#show', :as => 'follow'
  match '/docs/:doc_id' => 'docs#show', :as => 'comment'
  match '/create_comment/:doc_id' => 'docs#create_comment', :as => 'create_comment'
  match '/create_feature_comment/:feature_id' => 'features#create_feature_comment', :as => 'create_feature_comment'


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end