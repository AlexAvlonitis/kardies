class RemoveConversationNotifications < ActiveRecord::Migration[6.0]
  def change
    drop_table :conversation_notifications
  end
end
