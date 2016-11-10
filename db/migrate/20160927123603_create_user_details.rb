class CreateUserDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :user_details do |t|
      t.belongs_to :user, index: true, unique: true, foreign_key: true
      t.string :city, null: false, default: "athina-ATT"
      t.string :gender, null: false, default: "female"
      t.string :age, null: false, default: 30
      t.attachment :profile_picture
    end
  end
end
