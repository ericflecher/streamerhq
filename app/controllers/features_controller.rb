class FeaturesController < ApplicationController
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
    end
    
    if params[:feature_id]
      session[:feature_id] = params[:feature_id]
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

    #Used to determine document owner
     @feature.owner_list = current_user.id
     
     #Used to determin doc version
     @feature.version_list = 1


    respond_to do |format|
      if @feature.save
        @feature.baselineid_list = @feature.id
        @feature.save
        if doc.nil?
        else
          doc.follow(@feature) 
          session[:doc_id]= nil
          d = nil
          format.html { redirect_to doc, notice: 'Feature was successfully created.' }
        end
        
        if parent_feature.nil?
        else
          parent_feature.follow(@feature) 
          session[:feature_id]= nil
          f = nil
          format.html { redirect_to parent_feature, notice: 'Feature was successfully created.' }
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
        format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
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
    
    if @feature.parent_doc_list.nil?
      r = Doc.find(@feature.parent_doc_list)
      @feature.destroy

      respond_to do |format|
        format.html { redirect_to r }
        format.json { head :no_content }
      end
    else
      r = Doc.find(@feature.parent_doc_list)
      
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
    r = Doc.find(feature.parent_doc_list)
    commenter = current_user.id
    comment = params[:commenttext]
    
    
    @comment = Comment.build_from(feature, commenter, comment)
    @comment.save
  
    redirect_to doc_path(r)
  end
  
  def create_feature_comment_return_feature
    # create comment here
    featureid = params[:feature_id]
    feature = Feature.find(featureid)
    pf = feature.parent_feature_list
    if pf[0].nil?
      r = featureid
    else
      r = pf
    end
    commenter = current_user.id
    comment = params[:commenttext]
    
    
    @comment = Comment.build_from(feature, commenter, comment)
    @comment.save
  
    redirect_to feature_path(r)
  end
  
end