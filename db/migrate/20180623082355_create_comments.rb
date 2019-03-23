class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.string :commentable_type
      t.integer :commentable_id
      t.string :content, null: false, default: ''
      t.boolean :opened, default: false
      t.integer :reply_count, default: 0
      t.string :ip
      t.st_point :location, geography: true
      t.string :address
      t.timestamps null: false
    end
    add_index :comments, :user_id
    add_index :comments, :location, using: :gist
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
