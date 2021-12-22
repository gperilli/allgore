class AddBackdropImageUrlToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :backdrop_image_url, :string
  end
end
