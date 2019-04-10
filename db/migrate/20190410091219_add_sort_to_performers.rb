class AddSortToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :sort, :integer, default: 0
  end
end
