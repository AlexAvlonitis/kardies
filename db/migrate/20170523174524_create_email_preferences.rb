class CreateEmailPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :email_preferences do |t|
      t.belongs_to :user
      t.boolean :likes, default: true
      t.boolean :messages, default: true
      t.boolean :news, default: true
      t.timestamps
    end
  end
end
