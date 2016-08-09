class AddInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string, unique: true
    add_column :users, :profile_picture, :string

    add_index :users, :username
  end
end
