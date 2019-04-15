class AddMarryTypeToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :marry_type, :integer, default: 0
  end
end
