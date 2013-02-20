class AddFeacherverColumnToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :featurever_id, :integer
  end
end
