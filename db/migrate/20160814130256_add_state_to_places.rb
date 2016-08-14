class AddStateToPlaces < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :state, :string
  end
end
