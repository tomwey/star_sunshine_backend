class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :content, null: false, default: ''
      t.integer :from_user_id, null: false
      t.integer :to_user_id
      t.integer :comment_id, null: false
      t.boolean :opened, default: true
      t.string :ip
      t.string :address
      t.st_point :location, geography: true

      t.timestamps null: false
    end
    add_index :replies, :from_user_id
    add_index :replies, :to_user_id
    add_index :replies, :comment_id
    add_index :replies, :location, using: :gist
  end
end
