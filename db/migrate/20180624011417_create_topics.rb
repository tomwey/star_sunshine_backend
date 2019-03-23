class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :uniq_id
      t.text :content, null: false, default: ''
      
      t.string :topicable_type
      t.integer :topicable_id
      t.string :ownerable_type
      t.integer :ownerable_id
      t.integer :attachment_type # 0 表示关联的类型, 1 表示图片, 2 表示音频, 3 表示视频
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :views_count, default: 0
      t.string :ip
      t.string :address
      t.st_point :location, geography: true
      t.boolean :opened, default: true
      t.integer :sort, default: 0
      
      t.timestamps null: false
    end
    add_index :topics, :uniq_id, unique: true
    add_index :topics, [:ownerable_type, :ownerable_id]
    add_index :topics, :sort
    add_index :topics, :location, using: :gist
  end
end
