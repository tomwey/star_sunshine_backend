class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.integer :uniq_id
      t.string :title
      t.string :image, null: false
      t.string :link
      t.integer :sort, default: 0
      t.boolean :opened, default: true

      t.timestamps null: false
    end
    add_index :banners, :uniq_id, unique: true
  end
end
