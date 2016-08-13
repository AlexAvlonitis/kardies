class ChangePlacesColumns < ActiveRecord::Migration[5.0]
  def change
    change_column_null :places, :visit_date, false
    change_column_null :places, :country, false
  end
end
