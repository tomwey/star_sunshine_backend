class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :uniq_id
      t.integer :_type, null: false         # 1 表示电台 2 表示MV
      t.string :title, null: false          # 媒体资源标题
      t.string :summary                     # 媒体资源简介
      t.string :cover, null: false          # 封面图
      t.string :file                        # 音频或视频文件，适用于电台或MV
      t.string :play_url                    # 备用字段，如果加直播，那么直接是一个播放地址
      t.string :duration                    # 媒体资源播放时长
      t.integer :views_count, default: 0    # 播放次数
      t.integer :likes_count, default: 0    # like次数
      t.integer :comments_count, default: 0 # 评论数
      t.integer :danmu_count, default: 0    # 弹幕数
      t.integer :owner_id, null: false      # 所有者
      t.boolean :opened, default: true      # 是否上线该作品
      t.integer :sort, default: 0           # 显示顺序，值越大越靠前
      t.string :tags, array: true, default: [] # 所属标签

      t.timestamps null: false
    end
    add_index :media, :uniq_id, unique: true
    add_index :media, :_type
    add_index :media, :owner_id
    add_index :media, :tags, using: 'gin'
  end
end
