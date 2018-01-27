class RemovePersonalitiesDetailFromUserDetail < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_details, :personalities_detail, :text
  end
end
