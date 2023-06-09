class AddRuntimeToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :runtime, :integer
  end
end
