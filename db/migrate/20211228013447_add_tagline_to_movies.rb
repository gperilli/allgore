class AddTaglineToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :tagline, :string
  end
end
