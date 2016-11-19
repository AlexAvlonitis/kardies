class AddYoutubeUrlToAbout < ActiveRecord::Migration[5.0]
  def change
    add_column :abouts, :youtube_url, :string
  end
end
