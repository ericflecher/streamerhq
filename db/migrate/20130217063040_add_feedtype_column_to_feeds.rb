class AddFeedtypeColumnToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :feedtype, :text
  end
end
