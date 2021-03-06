class DocsController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :user, :email, :name
  
  
  # GET /docs
  # GET /docs.json
  def index
    
    #clean session variable
    session[:latest_version] = nil
    session[:latest_feature] = nil
    
    #@docs = Doc.all
    @docs = current_user.following_docs 
    @f = Array.new
    
    @docs.each do |d| 
      
      #f = Feed.where(:doc_id => d.id)
      f = Feed.where(['doc_id = ? AND user_id <> ?', d.id, current_user.id])
      @f += f  
    end
    
    @feeds = @f.sort_by &:created_at
    @feeds = @feeds.sort.reverse
    @since_last_login  = @feeds.select{|feed| feed.created_at >= current_user.last_sign_in_at }.size
    

    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @docs }
    end
  end

  # GET /docs/1
  # GET /docs/1.json
  def show
    
    #clean session variable
    session[:latest_version] = nil
    session[:latest_feature] = nil
    
    #feature modal create window... makes ure parent feature is null
    session[:parent_story_id] = nil
    
  
    #Adds doc as followed for current user
    if params[:doc_id]
      
      d = Doc.find(params[:doc_id])
      c = params[:follow_code]
      
      if c == 'f'
        current_user.follow(d)
      else
        current_user.stop_following(d)
      end
      
      @doc = Doc.find(d)

      
    else
      @doc = Doc.find(params[:id])
    end
    
    
    #populate board feed
    @feeds = Feed.where(:doc_id => @doc.id).order("created_at DESC")
    
  
    @since_last_login  = @feeds.select{|feed| feed.created_at >= current_user.last_sign_in_at }.size
    
    
    
    @users = current_user.following_user
    # deletes current following documnet from users list
    @u_followers = @doc.followers
  	@u_followers.each do |u| 
  	
  	    #x=@users.where(:id => u.id)
  		  #@users.delete x
		    
  	end
  	
  	#session[:u] = @u_followers
  	#session[:y] = @users
    
    @all_comments = @doc.comment_threads
    
    
    @features = @doc.following_features
    @features = @features.order("created_at ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @doc }
    end
  end

  # GET /docs/new
  # GET /docs/new.json
  def new
    @doc = Doc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @doc }
    end
  end

  # GET /docs/1/edit
  def edit
    @doc = Doc.find(params[:id])
  end

  # POST /docs
  # POST /docs.json
  def create
    @doc = Doc.new(params[:doc])
    
    user = current_user
    
    #Used to define document owner
    @doc.owner_list = current_user.id
    
    #Used to define doc version
    @doc.version_list = 1
    

    
    
    #make doc private by default
    @doc.pdoc = 1
    
    respond_to do |format|
      if @doc.save
        
        # adds a create event to the board feed
        feed = Feed.new 
        feed.message = "Created a new board - " + @doc.title
        feed.user_id = current_user.id
        feed.doc_id = @doc.id
        feed.feedtype = "Board create" 
        feed.save
        
        @doc.baselineid_list = @doc.id
        @doc.save
        user.follow(@doc) # Creates a record for the user as the follower and the book as the followable
        format.html { redirect_to @doc, notice: 'Board was successfully created.' }
        format.json { render json: @doc, status: :created, location: @doc }
      else
        format.html { render action: "new" }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /docs/1
  # PUT /docs/1.json
  def update
    @doc = Doc.find(params[:id])

    respond_to do |format|
      if @doc.update_attributes(params[:doc])
        format.html { redirect_to @doc, notice: 'Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docs/1
  # DELETE /docs/1.json
  def destroy
    @doc = Doc.find(params[:id])
    
    #remove all feeds for a doc
    f = Feed.where(:doc_id => @doc.id)
    f.each do |x| 
      x.destroy
    end
    
    @doc.destroy


    

    respond_to do |format|
      format.html { redirect_to docs_url }
      format.json { head :no_content }
    end
  end
  
  def create_comment
    # create comment here
    docid = params[:doc_id]
    
    doc = Doc.find(docid)
    commenter = current_user.id
    comment = params[:commenttext]
    
    
    @comment = Comment.build_from(doc, commenter, comment)
    @comment.save
    
    # adds a create event to the board feed
    feed = Feed.new 
    feed.message = comment
    feed.user_id = current_user.id
    feed.doc_id = doc.id
    feed.feedtype = "Board comment" 
    feed.save
    
     # email notificaiton
     feature = 1
      @followers = doc.followers

      @followers.each do |f|
        user = current_user
        send_to_user = f
        # Tell the UserMailer to send a welcome Email after save
        
        UserMailer.comment_email(user, doc, feature, comment, send_to_user).deliver
      end
    
    redirect_to doc_path(docid)
  end
  
  def add_follower
    
    d = params[:doc_id]
    e = params[:user]
    email = params[:email]
    doc = Doc.find(Integer(d))
    if email == ""
      
      user = User.find(e)
      #session[:test] = user
      user.follow(doc)
     
      
    else
      
      existing_u = User.where(:email => email)
      
      if existing_u.blank?
      
        User.invite!({:email => email}, current_user) # current_user will be set as invited_by
        new_user = User.where(:email => email)
      
        x = CustomAss.new
        x.doc_id = doc.id
        x.codetype = email
        x.save
        
      
      else
        
        existing_u[0].follow(doc)
        current_user.follow(existing_u[0])
       
      end
      
    end
    
    redirect_to doc
    
  end
  
  def remove_follower
    
    d = params[:doc_id]
    e = params[:user_id]
   
    user = User.find(e)
    #session[:test] = user

    doc = Doc.find(Integer(d))
    user.stop_following(doc)
    
    redirect_to doc
    
  end
  
  def make_admin
    
    d = params[:doc_id]
    e = params[:user_id]
   
    user = User.find(e)
    doc = Doc.find(Integer(d))
    
    tags = doc.owner_list
    tags.push(String(user.id))
    
    #Used to define document owner
    doc.owner_list = tags
    #session[:test]=tags
    
    doc.save
    redirect_to doc
    
  end
  
  def remove_admin
    
    d = params[:doc_id]
    e = params[:user_id]
   
    user = User.find(e)
    doc = Doc.find(Integer(d))
    
    tags = doc.owner_list
    tags.delete String(user.id)
    
    #Used to define document owner
    doc.owner_list = tags
    #session[:test]=tags
    
    doc.save
    redirect_to doc
    
  end
  
  # makes a document public or private
  def pdoc
    d = params[:doc_id]
    doc = Doc.find(d)
    
    if doc.pdoc == 1
      doc.pdoc = 0
    else
      doc.pdoc = 1
    end
   
    doc.save
    redirect_to doc
  end
  
  # archives a document
  def arch
    
    d = params[:doc_id]
    doc = Doc.find(d)
    
    #session[:d] = doc
    
    if doc.arch  == 1
      
      doc.arch = 0
      
    else
      
      doc.arch = 1
      
    end
    
    doc.save
    
    redirect_to docs_path
    
  end
  
  
end
