class CreateMembershipTable < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.string "customer_id"
      t.string "subscription_id"
      t.datetime "expiry_date"
      t.boolean "active"

      t.references :user
      t.timestamps
      t.index ["subscription_id"]
    end
  end
end
