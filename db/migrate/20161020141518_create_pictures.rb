class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.attachment :picture
      t.references :gallery, foreign_key: true

      t.timestamps
    end
  end
end
