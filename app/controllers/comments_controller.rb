class CommentsController < ApplicationController
  
  def remove_comment
    docid = params[:doc_id]
    doc = Doc.find(docid)
    commentid = params[:comment_id]
    comment = Comment.find(commentid)  
    comment.destroy    
    redirect_to doc_path(docid)
  end
  
  def remove_feature_comment
    featureid = params[:feature_id]
    feature = Feature.find(featureid)
    commentid = params[:comment_id]
    comment = Comment.find(commentid)  
    comment.destroy    
    redirect_to feature_path(featureid)
  end
  
  def remove_version_comment
    versionid = params[:version_id]
    version = Featurever.find(versionid)
    commentid = params[:comment_id]
    comment = Comment.find(commentid)  
    comment.destroy    
    redirect_to feature_path(version.featureid)
  end
  
end