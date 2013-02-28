class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :doc_id
      t.integer :feature_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
