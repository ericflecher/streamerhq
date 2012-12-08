class AddPdocToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :pdoc, :integer
  end
end
