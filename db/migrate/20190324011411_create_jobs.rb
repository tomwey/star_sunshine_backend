class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :uniq_id
      t.string :name, null: false, default: ''
      t.text :body
      t.string :address
      t.string :price
      t.datetime :begin_time
      t.datetime :end_time
      t.string :company
      t.boolean :opened, default: true
      t.datetime :deleted_at
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :jobs, :uniq_id, unique: true
  end
end
