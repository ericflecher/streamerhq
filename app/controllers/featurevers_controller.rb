class FeatureversController < ApplicationController
  
  
  def versions
    
    @feature = Feature.find(params[:feature_id])
    
    @featurevers = Featurever.all
    
    redirect_to featurevers_path
    
  end
  
  
  def create_version_comment_return_feature
    
    # create comment here
    versionid = params[:version_id]
    version = Featurever.find(versionid)
  
    commenter = current_user.id
    comment = params[:commenttext]
    
    @comment = Comment.build_from(version, commenter, comment)
    @comment.save
    
    # email notificaiton
    d = params[:doc_id]
    doc = Doc.find(d)
    @followers = doc.followers
    
    @followers.each do |f|
     # user = current_user
    #  send_to_user = f
      # Tell the UserMailer to send a welcome Email after save
      #UserMailer.comment_email(user, doc, feature, comment).deliver
     # UserMailer.comment_email(user, doc, version.featureid, comment, send_to_user).deliver
    end
    
    # adds a comment event to the board feed
    feed = Feed.new
        
    feed.message = comment
    feed.featurever_id = version.id
    feed.user_id = current_user.id
    feed.feedtype = "Version comment"
    feed.doc_id = doc.id
    feed.save

  
    redirect_to feature_path(version.featureid)
  
  end
  
  
  
  # GET /featurevers
  # GET /featurevers.json
  def index
    
    @feature = Feature.find(params[:feature_id])
    pf = @feature.parent_feature_list

    if pf[0].nil?
      @feature_redirect = @feature.id
    else
      @feature_redirect = pf
    end
  
    @versions = Featurever.where(:featureid => @feature.id).order('created_at DESC')
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @featurevers }
    end
  end

  # GET /featurevers/1
  # GET /featurevers/1.json
  def show
    @featurever = Featurever.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @featurever }
    end
  end

  # GET /featurevers/new
  # GET /featurevers/new.json
  def new
   
    @feature = Feature.find(params[:feature_id])
    
    pf = @feature.parent_feature_list
    
    if pf[0].nil?
      @feature_redirect = @feature.id
    else
      @feature_redirect = pf
    end
    
    @versions = Featurever.where(:featureid => @feature.id).sort.reverse
    
    session[:feature_id] = @feature.id
    
    @featurever = Featurever.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @featurever }
    end
  end

  # GET /featurevers/1/edit
  def edit
    @featurever = Featurever.find(params[:id])
  end

  # POST /featurevers
  # POST /featurevers.json
  def create
    @featurever = Featurever.new(params[:featurever])
    feature_id = session[:feature_id]
    @feature = Feature.find(feature_id)
    
    @featurever.featureid = feature_id
    
    pf = @feature.parent_feature_list
    
    if pf[0].nil?
      feature_redirect = @feature.id
    else
      feature_redirect = pf
    end

    respond_to do |format|
      if @featurever.save
        
        
        # adds a create event to the board feed
        feed = Feed.new
        
        feed.message = "Updated"
        feed.featurever_id = @featurever.id
        feed.user_id = current_user.id
        feed.doc_id = @feature.parent_doc_list[0]
        feed.feedtype = "Feature version create"
        feed.save
        
        
        
        
        session[:feature_id] = nil
        format.html { redirect_to feature_path(feature_redirect), notice: 'New story saved.' }
        format.json { render json: @featurever, status: :created, location: @featurever }
      else
        format.html { render action: "index" }
        format.json { render json: @featurever.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /featurevers/1
  # PUT /featurevers/1.json
  def update
    
    
    feature_id = session[:feature_id]
    @feature = Feature.find(feature_id)
    
    pf = @feature.parent_feature_list
    
    if pf[0].nil?
      feature_redirect = @feature.id
    else
      feature_redirect = pf
    end
    
    @featurever = Featurever.find(params[:id])
    
    @featurever.featureid = feature_id

    respond_to do |format|
      if @featurever.update_attributes(params[:featurever])
        
        
        # adds a create event to the board feed
        feed = Feed.new
        
        feed.message = "Updated"
        feed.featurever_id = @featurever.id
        feed.user_id = current_user.id
        feed.doc_id = @feature.parent_doc_list[0]
        feed.feedtype = "Feature version update"
        feed.save
        
        
        format.html { redirect_to feature_path(feature_redirect), notice: 'Your story successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @featurever.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featurevers/1
  # DELETE /featurevers/1.json
  def destroy
    @featurever = Featurever.find(params[:id])
    feature = Feature.find(@featurever.featureid)
    r = Doc.find(feature.parent_doc_list)
    

    #remove all feeds for a doc
    f = Feed.where(:featurever_id => @featurever.id)
    f.each do |x| 
      x.destroy
    end


    
    @featurever.destroy
    
    
    
     pf = feature.parent_feature_list

      if pf[0].nil?
        feature_redirect = feature.id
      else
        feature_redirect = pf
      end

    respond_to do |format|
      format.html { redirect_to feature_path(feature_redirect)}
      format.json { head :no_content }
    end
  end
end
