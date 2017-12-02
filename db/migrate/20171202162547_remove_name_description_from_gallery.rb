class RemoveNameDescriptionFromGallery < ActiveRecord::Migration[5.0]
  def change
    remove_column :galleries, :name, :string
  end
end
