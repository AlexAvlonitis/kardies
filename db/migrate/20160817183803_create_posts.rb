class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string  :title, null: false
      t.text    :body, limit: 400, null: false
      t.timestamps
    end
    add_reference :posts, :user, index: true
  end
end
