class CreateUserActionLimits < ActiveRecord::Migration[6.1]
  def change
    create_table :user_action_limits do |t|
      t.integer :user_id, null: false
      t.string :action_type, null: false
      t.integer :count, null: false, default: 0
      t.datetime :last_reset_at
      t.timestamps
    end

    add_index :user_action_limits, [:user_id, :action_type], unique: true
    add_foreign_key :user_action_limits, :users, column: :user_id
  end
end
