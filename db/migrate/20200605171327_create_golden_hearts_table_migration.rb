class CreateGoldenHeartsTableMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :golden_hearts do |t|
      t.references :heartable, polymorphic: true, add_index: true
      t.references :hearter, polymorphic: true, add_index: true
      t.timestamps
    end
  end
end
