# frozen_string_literal: true

require 'csv'

require_relative 'get_tmdb_movies'

def generate_csv_from_api_search
  # get horror movies from TMDB api
  # tmdb has about 704,457 movies
  new_movie_index = 10_729
  horror_movies_n = 1
  movie_titles_array = []
  movie_hash_for_csvarray = get_tmdb_movies(new_movie_index, horror_movies_n, movie_titles_array, 121)

  # Writing Movie Seeds to CSV
  csv_file = "db/seed/#{Time.now.strftime('%Y-%m-%d-%H-%M')}_api_import_list_movies.csv"
  puts 'Putting TMDB movie seeds into csv file'
  CSV.open(csv_file, 'wb') do |csv|
    movie_hash_for_csvarray.each do |movie_data|
      csv << [movie_data[:tmdb_key], movie_data[:title], movie_data[:poster_url], movie_data[:backdrop_image_url],
              movie_data[:overview], movie_data[:release_date], movie_data[:runtime], movie_data[:tagline], movie_data[:rating], movie_data[:language], 'No Category']
    end
  end
end

generate_csv_from_api_search
