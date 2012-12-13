class UserMailer < ActionMailer::Base
  default from: "bckto@2one6.com"
  
  def notificaiton_email(user)
      @user = current_user
      @url  = feature_path(@feature)
      mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
  
  def comment_email(user, doc, feature, comment, send_to_user)
    @user = user
    @doc = doc
    @feature = feature
    @comment = comment
    @send_to_user = send_to_user
    if @feature == 1
      @url  = "http://www.bckto.com" + doc_path(@doc)
    else
      @url  = "http://www.bckto.com" + feature_path(@feature)
    end
      mail(:to => @send_to_user.email,:subject => "New comment") do |format|
           format.html { render '/user_mailer/comment_email' }
         
      end
    
  end
  
end
