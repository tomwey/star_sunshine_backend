class AddPhoneAndNicknameToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :phone, :string
    add_column :performers, :nickname, :string
  end
end
