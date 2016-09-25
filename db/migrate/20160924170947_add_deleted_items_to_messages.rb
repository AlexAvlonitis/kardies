class AddDeletedItemsToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :deleted_inbox, :boolean
    add_column :messages, :deleted_sent, :boolean
  end
end
