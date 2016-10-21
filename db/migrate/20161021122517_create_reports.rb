class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :reason
      t.text :description
      t.integer :reporter_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
