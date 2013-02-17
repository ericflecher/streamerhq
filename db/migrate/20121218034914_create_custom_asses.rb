class CreateCustomAsses < ActiveRecord::Migration
  def change
    create_table :custom_asses do |t|
      t.integer :user_id
      t.integer :feature_id
      t.integer :doc_id
      t.text :codetype

      t.timestamps
    end
  end
end
