class RemoveDescriptionFromGalleries < ActiveRecord::Migration[5.0]
  def change
    remove_column :galleries, :description
  end
end
