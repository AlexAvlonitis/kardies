class RemoveProfilePictureFromUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :profile_picture
  end
end
