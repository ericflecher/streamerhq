Streamerhq::Application.routes.draw do
  
  resources :features
  resources :docs
  resources :custom_ass
  resources :comments, :only => [:create, :destroy]
  
  match '/feature/new/:feature_id' => 'features#new', :as => 'new'
  match '/follow/:doc_id/:follow_code' => 'docs#show', :as => 'follow'
  match '/docs/:doc_id' => 'docs#show', :as => 'comment'
  match '/create_comment/:doc_id' => 'docs#create_comment', :as => 'create_comment'
  match '/create_feature_comment/:feature_id/:doc_id' => 'features#create_feature_comment', :as => 'create_feature_comment'
  match '/create_feature_comment_return_feature/:feature_id/:doc_id' => 'features#create_feature_comment_return_feature', :as => 'create_feature_comment_return_feature'
  match '/remove_comment/:doc_id/:comment_id' => 'comments#remove_comment', :as => 'remove_comment'
  match '/remove_feature_comment/:feature_id/:comment_id' => 'comments#remove_feature_comment', :as => 'remove_feature_comment'
  match '/add_follower/:doc_id' => 'docs#add_follower', :as => 'add_follower'
  match '/remove_follower/:doc_id/:user_id' => 'docs#remove_follower', :as => 'remove_follower'
  match '/nf/:doc_id' => 'features#new', :as => 'nf'
  match '/pdoc/:doc_id' => 'docs#pdoc', :as => 'pdoc'
  match '/make_admin/:doc_id/:user_id' => 'docs#make_admin', :as => 'make_admin'
  match '/remove_admin/:doc_id/:user_id' => 'docs#remove_admin', :as => 'remove_admin'
  match '/followuser/:user_id/:follow_code' => 'users#followuser', :as => 'followuser'
  
  
  


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users, controllers: { invitations: 'devise/invitations' }
  #devise_for :users, :controllers => { :invitations => 'users/invitations' }
  resources :users
  
  resources :users do
    get :autocomplete_user_name, :on => :collection
  end
  
end