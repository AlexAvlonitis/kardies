class AddMembershipDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :amount, :integer
    add_column :memberships, :interval, :string
    add_column :memberships, :interval_count, :integer
  end
end
