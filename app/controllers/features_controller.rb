class FeaturesController < ApplicationController
  before_filter :authenticate_user!
  # GET /features
  # GET /features.json
  def index
    @features = Feature.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end

  # GET /features/1
  # GET /features/1.json
  def show
    @feature = Feature.find(params[:id])
    session[:parent_story_id] = @feature.id
    
    session[:doc_id]= nil
    session[:feature_id] = nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/new
  # GET /features/new.json
  def new
    @feature = Feature.new
    
    if params[:doc_id]
      session[:doc_id] = params[:doc_id]
      @r = session[:doc_id]
    end
    
    if params[:feature_id]
      session[:feature_id] = params[:feature_id]
      @r = session[:feature_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(params[:feature])
    
    # adding a feature
    d = session[:doc_id]
    if d.nil?
    else
      doc = Doc.find(d)
      @feature.parent_doc_list = doc.id
    end
    
    # adding a sub-feature
    f = session[:feature_id]
    if f.nil?
         
    else
      parent_feature = Feature.find(f)
      @feature.parent_feature_list = parent_feature.id
      @feature.parent_doc_list = parent_feature.parent_doc_list
    end
    
    #created to support modal window
    substory = session[:parent_story_id]
    if substory.nil?
    else
         parent_feature = Feature.find(substory)
         @feature.parent_feature_list = parent_feature.id
         @feature.parent_doc_list = parent_feature.parent_doc_list
    end

    #Used to determine document owner
     @feature.owner_list = current_user.id
     
     #Used to determin doc version
     @feature.version_list = 1


    respond_to do |format|
      if @feature.save
        @feature.baselineid_list = @feature.id
        @feature.save
        
        # adds a create event to the board feed
        feed = Feed.new
        
        feed.message = "Created a new story - " + @feature.title
        feed.feature_id = @feature.id
        feed.user_id = current_user.id
        feed.doc_id = Doc.find(@feature.parent_doc_list[0]).id
        feed.feedtype = "Feature create" 
        feed.save
        
        if doc.nil?
        else
          doc.follow(@feature) 

          
          # email notificaiton
          doc = Doc.find(d)
          @followers = doc.followers

          @followers.each do |f|
            user = current_user
            send_to_user = f
            # Tell the UserMailer to send a welcome Email after save
            #UserMailer.comment_email(user, doc, feature, comment).deliver
            UserMailer.section_email(user, doc, @feature, send_to_user).deliver
          end
          
          d = nil
          session[:doc_id]= nil
          session[:parent_story_id] = nil
          session[:feature_id]= nil
          format.html { redirect_to doc, notice: 'Story was successfully created.' }
        end
        
        if parent_feature.nil?
        else
          parent_feature.follow(@feature) 
          
          # email notificaiton
          doc = Doc.find(@feature.parent_doc_list[0])
          @followers = doc.followers

          @followers.each do |f|
            user = current_user
            send_to_user = f
            # Tell the UserMailer to send a welcome Email after save
            #UserMailer.comment_email(user, doc, feature, comment).deliver
            UserMailer.section_email(user, doc, @feature, send_to_user).deliver
          end
          
          session[:feature_id]= nil
          session[:doc_id] = nil
          #sub feature modal 
          session[:parent_story_id] = nil
          f = nil
          format.html { redirect_to parent_feature, notice: 'Story was successfully created.' }
        end
        
        
        format.json { render json: @feature, status: :created, location: @feature }
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.json
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        
        
        # adds a create event to the board feed
        feed = Feed.new
        
        feed.message = "Updated" + @feature.title
        feed.feature_id = @feature.id
        feed.user_id = current_user.id
        feed.doc_id = @feature.parent_doc_list[0]
        feed.feedtype = "Feature update" 
        feed.save
        
        
        # email notificaiton
        doc = Doc.find(@feature.parent_doc_list[0])
        @followers = doc.followers

        @followers.each do |f|
          user = current_user
          send_to_user = f
          # Tell the UserMailer to send a welcome Email after save
          #UserMailer.comment_email(user, doc, feature, comment).deliver
          UserMailer.section_email(user, doc, @feature, send_to_user).deliver
        end
        
        format.html { redirect_to @feature, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature = Feature.find(params[:id])
    
    #remove all feeds for a doc
    f = Feed.where(:feature_id => @feature.id)
    f.each do |x| 
      x.destroy
    end
    
    
    if @feature.parent_doc_list.nil?
      r = Doc.find(@feature.parent_doc_list)
      
      # adds a create event to the board feed
      feed = Feed.new
        
      feed.message = "Deleted: " + @feature.title
      feed.feature_id = @feature.id
      feed.user_id = current_user.id
      feed.doc_id = r.id
        
      feed.save
      
      @feature.destroy

      respond_to do |format|
        format.html { redirect_to r }
        format.json { head :no_content }
      end
    else
      r = Doc.find(@feature.parent_doc_list)
      
      # adds a create event to the board feed
      feed = Feed.new
        
      feed.message = "Deleted: " + @feature.title
      feed.feature_id = @feature.id
      feed.user_id = current_user.id
      feed.doc_id = r[0].id
      feed.feedtype = "Feature delete"  
      feed.save
      
      @feature.destroy

      respond_to do |format|
        format.html { redirect_to r }
        format.json { head :no_content }
      end
    end
    
  end
  
  def create_feature_comment
    # create comment here
    featureid = params[:feature_id]
    feature = Feature.find(featureid)
    doc = Doc.find(feature.parent_doc_list)
    commenter = current_user.id
    comment = params[:commenttext]
    
   
    
    @comment = Comment.build_from(feature, commenter, comment)
    @comment.save
    
    # email notificaiton
    d = params[:doc_id]
    doc = Doc.find(d)
    @followers = doc.followers
    
    @followers.each do |f|
      send_to_user = f
      user = current_user
      # Tell the UserMailer to send a welcome Email after save
      UserMailer.comment_email(user, doc, feature, comment, send_to_user).deliver
      
    end
    
    # adds a comment event to the board feed
    feed = Feed.new
        
    feed.message = comment
    feed.feature_id = feature.id
    feed.doc_id = doc.id
    feed.user_id = current_user.id
    feed.feedtype = "Feature comment" 
    feed.save
    
    redirect_to doc_path(doc)
  end
  
  def create_feature_comment_return_feature
    # create comment here
    featureid = params[:feature_id]
    feature = Feature.find(featureid)
    pf = feature.parent_feature_list
    
    
    
    if pf[0].nil?
      f = featureid
    else
      f = pf
    end
    commenter = current_user.id
    comment = params[:commenttext]
    
    @comment = Comment.build_from(feature, commenter, comment)
    @comment.save
    
    # email notificaiton
    d = params[:doc_id]
    doc = Doc.find(d)
    @followers = doc.followers
    
    @followers.each do |f|
      user = current_user
      send_to_user = f
      # Tell the UserMailer to send a welcome Email after save
      #UserMailer.comment_email(user, doc, feature, comment).deliver
      UserMailer.comment_email(user, doc, feature, comment, send_to_user).deliver
    end
    
    # adds a comment event to the board feed
    feed = Feed.new
        
    feed.message = comment
    feed.feature_id = feature.id
    feed.user_id = current_user.id
    feed.doc_id = doc.id
    feed.feedtype = "Feature comment" 
    feed.save

    
  
    redirect_to feature_path(f)
  end
  
end
