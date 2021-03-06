class Doc < ActiveRecord::Base
  attr_accessible :description, :title, :photo, :version, :owner, :private, :arch
  
  acts_as_followable
  acts_as_follower
  acts_as_commentable
  
  #validates_length_of :description, :maximum => 250, :message => "less than 250 characters please"

  # Alias for <tt>acts_as_ordered_taggable_on :tags</tt>:
  acts_as_taggable_on :version, :baselineid, :owner, :private, :archived
  scope :by_join_date, order("created_at DESC")
  
  has_attached_file :photo,
      :styles =>{
      :thumb  => "100x100",
      :medium => "200x200",
      :large => "600x400"
    },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":attachment/:id/:style.:extension",
    :bucket => 'streamerhq_doc'
  
end
