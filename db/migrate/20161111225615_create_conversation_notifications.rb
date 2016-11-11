class CreateConversationNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :conversation_notifications do |t|
      t.references :user, foreign_key: true
      t.references :receiver, index: true
      t.boolean :received
      t.timestamps
    end
  end
end
