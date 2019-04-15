class AddUserIdAndApprovedAtToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :user_id, :integer
    add_index :performers, :user_id
    add_column :performers, :approved_at, :datetime
  end
end
