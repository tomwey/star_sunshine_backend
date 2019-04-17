class AddSortToTags < ActiveRecord::Migration
  def change
    add_column :tags, :sort, :integer, default: 0
  end
end
