class RemoveCityFromUserDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_details, :city
  end
end
