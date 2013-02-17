class Feed < ActiveRecord::Base
  attr_accessible :doc_id, :feature_id, :message, :user_id
end
