class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string   :country
      t.string   :city
      t.date     :visit_date
      t.timestamps
    end
    add_reference :places, :user, index: true
  end
end
