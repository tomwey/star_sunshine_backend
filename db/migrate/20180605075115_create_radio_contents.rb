class CreateRadioContents < ActiveRecord::Migration
  def change
    create_table :radio_contents do |t|
      t.integer :media_id, index: true
      t.string :lyrics
      t.string :composer
      t.string :original_singer
      t.text :content

      t.timestamps null: false
    end
  end
end
