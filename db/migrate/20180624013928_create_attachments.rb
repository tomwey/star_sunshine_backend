class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachable_type
      t.integer :attachable_id
      
      t.string :data_file_name
      t.string :data_content_type
      t.integer :data_file_size
      
      t.string :ownerable_type
      t.integer :ownerable_id
      
      t.string :ip
      t.string :address
      t.st_point :location, geography: true
      
      t.boolean :opened, default: true

      t.timestamps null: false
    end
    add_index :attachments, [:attachable_type, :attachable_id]
    add_index :attachments, [:ownerable_type, :ownerable_id]
    add_index :attachments, :location, using: :gist
  end
end
