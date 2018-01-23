class AddPersonalityDetailsToUserDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :user_details, :personalities_detail, :text
  end
end
