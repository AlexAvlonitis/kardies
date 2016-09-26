class AddPostedByToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :posted_by, :integer, null: false
    add_index :messages, :posted_by
  end
end