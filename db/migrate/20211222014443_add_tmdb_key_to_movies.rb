class AddTmdbKeyToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :tmdb_key, :integer
  end
end
