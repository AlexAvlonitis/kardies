class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :body
      t.boolean :wall_shared, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
