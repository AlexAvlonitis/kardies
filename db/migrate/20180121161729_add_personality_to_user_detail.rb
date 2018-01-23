class AddPersonalityToUserDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :user_details, :personalities, :string
  end
end
