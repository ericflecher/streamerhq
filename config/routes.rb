Streamerhq::Application.routes.draw do
  
  resources :featurevers
  resources :feeds
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
  match '/versions/:feature_id' => 'featurevers#versions', :as => 'versions'
  match '/featurevers/index/:feature_id' => 'featurevers#index', :as => 'versions'
  match '/featurevers/new/:feature_id' => 'featurevers#new', :as => 'newversion'
  match '/create_version_comment_return_feature/:version_id/:doc_id' => 'featurevers#create_version_comment_return_feature', :as => 'create_version_comment_return_feature'
  match '/remove_version_comment/:version_id/:comment_id' => 'comments#remove_version_comment', :as => 'remove_version_comment'
  match '/arch/:doc_id' => 'docs#arch', :as => 'arch'


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