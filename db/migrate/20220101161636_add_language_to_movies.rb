class AddLanguageToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :language, :string
  end
end
