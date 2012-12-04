Streamerhq::Application.routes.draw do
  
  resources :features
  resources :docs
  resources :comments, :only => [:create, :destroy]
  
  match '/feature/new/:doc_id' => 'features#new', :as => 'new'
  match '/feature/new/:feature_id' => 'features#new', :as => 'new'
  match '/follow/:doc_id/:follow_code' => 'docs#show', :as => 'follow'
  match '/docs/:doc_id' => 'docs#show', :as => 'comment'
  match '/create_comment/:doc_id' => 'docs#create_comment', :as => 'create_comment'
  match '/create_feature_comment/:feature_id' => 'features#create_feature_comment', :as => 'create_feature_comment'
  match '/create_feature_comment_return_feature/:feature_id' => 'features#create_feature_comment_return_feature', :as => 'create_feature_comment_return_feature'
  match '/remove_comment/:doc_id/:comment_id' => 'comments#remove_comment', :as => 'remove_comment'
  match '/remove_feature_comment/:feature_id/:comment_id' => 'comments#remove_feature_comment', :as => 'remove_feature_comment'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end