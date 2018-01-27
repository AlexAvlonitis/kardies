class CreatePersonalitiesDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :personalities do |t|
      t.string :code
      t.text :detail
      t.timestamps
    end
  end
end
