class CreateMediaPlayLogs < ActiveRecord::Migration
  def change
    create_table :media_play_logs do |t|
      t.integer :user_id
      t.integer :media_id
      t.string :ip
      t.st_point :location, geographic: true
      
      t.timestamps null: false
    end
    add_index :media_play_logs, :media_id
    add_index :media_play_logs, :user_id
    add_index :media_play_logs, :location, using: :gist
  end
end
