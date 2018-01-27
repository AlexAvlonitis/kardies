class RenamePersonalitiesToPersonalityTypeFromUserDetail < ActiveRecord::Migration[5.1]
  def change
    rename_column :user_details, :personalities, :personality_type
  end
end
