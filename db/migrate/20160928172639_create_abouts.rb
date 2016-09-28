class CreateAbouts < ActiveRecord::Migration[5.0]
  def change
    create_table :abouts do |t|
      t.belongs_to :user, index: true, unique: true, foreign_key: true
      t.string :job
      t.string :hobby
      t.string :relationship_status
      t.string :looking_for
      t.text :description, limit: 1000
      t.timestamps
    end
  end
end
