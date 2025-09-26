class AddSortByToSearchCriteria < ActiveRecord::Migration[6.1]
  def change
    add_column :search_criteria, :sort_by, :string, default: 'desc'
  end
end
