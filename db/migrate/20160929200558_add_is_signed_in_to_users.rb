class AddIsSignedInToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_signed_in, :boolean, default: 0
  end
end
