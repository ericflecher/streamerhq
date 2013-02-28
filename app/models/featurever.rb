class Featurever < ActiveRecord::Base
  attr_accessible :gherkin, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at, :title, :photo, :featureid
  
  acts_as_follower
  acts_as_followable
  acts_as_commentable
  
  acts_as_taggable_on :version,:baselineid, :owner, :parent_feature, :parent_doc
  
  
  
  has_attached_file :photo,
      :styles =>{
      :thumb  => "100x100",
      :medium => "200x200",
      :large => "600x400"
    },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":attachment/:id/:style.:extension",
    :bucket => 'streamerhq_featurever'
  
end
