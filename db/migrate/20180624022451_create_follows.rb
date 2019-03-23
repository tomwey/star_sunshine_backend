class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.string :followable_type
      t.integer :followable_id

      t.timestamps null: false
    end
    add_index :follows, :user_id
    add_index :follows, :followable_type
    add_index :follows, [:followable_type, :followable_id]
  end
end
