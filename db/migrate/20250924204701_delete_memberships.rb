class DeleteMemberships < ActiveRecord::Migration[6.1]
  def change
    drop_table :memberships if table_exists?(:memberships)
    drop_table :user_action_limits if table_exists?(:user_action_limits)
  end
end
