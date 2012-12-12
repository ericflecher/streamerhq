class UserMailer < ActionMailer::Base
  default from: "bckto@2one6.com"
  
  def notificaiton_email(user)
      @user = user
      @url  = feature_path(@feature)
      mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
  
  def comment_email(user, doc, feature, comment)
    @user = user
    @doc = doc
    @feature = feature
    @comment = comment
    if @feature == 1
      @url  = "http://www.bckto.com" + doc_path(@doc)
    else
      @url  = "http://www.bckto.com" + feature_path(@feature)
    end
      mail(:to => @user.email,:subject => "New comment") do |format|
           format.html { render '/user_mailer/comment_email' }
         
      end
    
  end
  
end
