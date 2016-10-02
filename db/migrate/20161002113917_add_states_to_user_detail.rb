class AddStatesToUserDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :user_details, :state, :string, null: false
  end
end
