class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text   :body, null: false
      t.timestamps
    end
    add_reference :messages, :user, index: true
  end
end
