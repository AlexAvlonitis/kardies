class CreateUserDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :user_details do |t|
      t.belongs_to :user, index: true, unique: true, foreign_key: true
      t.string :city, null: false
      t.string :gender, null: false
      t.date   :age, null: false
      t.attachment :profile_picture
    end
  end
end
