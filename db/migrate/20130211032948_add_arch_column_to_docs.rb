class AddArchColumnToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :arch, :int
  end
end
