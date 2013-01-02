class CreateFeaturevers < ActiveRecord::Migration
  def change
    create_table :featurevers do |t|
      t.string :title
      t.text :gherkin
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.timestamp :photo_updated_at

      t.timestamps
    end
  end
end
