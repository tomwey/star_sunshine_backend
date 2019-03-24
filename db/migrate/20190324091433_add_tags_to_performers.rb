class AddTagsToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :tags, :integer, array: true, default: []
    add_index :performers, :tags, using: :gin
  end
end
