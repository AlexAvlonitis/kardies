class CreateSearchCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :search_criteria do |t|
      t.belongs_to :user
      t.string :state
      t.string :city
      t.string :gender
      t.integer :age_from, default: 18
      t.integer :age_to, default: 99
      t.boolean :is_signed_in, default: false
      t.timestamps
    end
  end
end
