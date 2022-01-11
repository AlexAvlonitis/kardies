class AddFirstSignInToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_sign_in, :boolean, default: true
  end
end
