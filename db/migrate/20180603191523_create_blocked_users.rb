class CreateBlockedUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :blocked_users do |t|
      t.references :user
      t.integer :blocked_user_id

      t.index :blocked_user_id
      t.timestamps
    end
  end
end
