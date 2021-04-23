class AddTypeToNews < ActiveRecord::Migration[6.0]
  def change
    remove_column :news, :title, :string
    remove_column :news, :body, :text
    add_column :news, :meta, :json, default: {}
    add_column :news, :type, :string
  end
end
