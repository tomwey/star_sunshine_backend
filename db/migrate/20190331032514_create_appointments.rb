class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id, null: false, index: true
      t.integer :job_id, null: false, index: true
      t.string :name, null: false
      t.string :phone, null: false
      t.string :address

      t.timestamps null: false
    end
    # add_index :appointments, [:user_id, :job_id]
  end
end
