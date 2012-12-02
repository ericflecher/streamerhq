class Feature < ActiveRecord::Base
  attr_accessible :gherkin, :title, :photo
  
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
    :bucket => 'streamerhq_feature'
  
end
