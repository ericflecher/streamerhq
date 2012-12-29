class UsersController < ApplicationController
  before_filter :authenticate_user!

  def followuser
    
    #follow a user feature
    if params[:user_id]
      
      follow = User.find(params[:user_id])
      c = params[:follow_code]
      
      if c == 'f'
        current_user.follow(follow)
      else
        current_user.stop_following(follow)
      end

    end
    
    redirect_to follow
  end


  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @docs = @user.following_docs
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end

