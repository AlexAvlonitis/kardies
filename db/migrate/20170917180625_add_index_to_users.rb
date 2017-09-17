class AddIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :provider
    add_index :users, :uid
  end
end
