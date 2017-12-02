class RemoveYoutubeColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :abouts, :youtube_url, :string
  end
end
