class AddFeatureidToFeaturever < ActiveRecord::Migration
  def change
    add_column :featurevers, :featureid, :integer
  end
end
