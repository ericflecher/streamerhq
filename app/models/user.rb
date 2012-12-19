class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  acts_as_follower
  acts_as_followable
  
  
  after_invitation_accepted :email_invited_by

  def email_invited_by
     # add users to all invited documents
     
     
     
     invites = CustomAss.where(:codetype => self.email)
     
     invites.each do |i|
       
       u = User.where(:email => i.codetype)
       d = Doc.find(i.doc_id)
       
       self.follow(d)
       
     end
     
     
  end
  
  
end
