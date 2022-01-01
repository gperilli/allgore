# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'json'
require "nokogiri"
require 'csv'

require_relative 'waiting_dots'
require_relative 'seed_tmdb_movies'
require_relative 'create_movie_lists'

seed_from_tmdb = false

puts 'cleaning up database'
waiting_dots
Movie.destroy_all
List.destroy_all
Movielistconnector.destroy_all
puts 'databse is clean'

puts 'Creating horror movies'
waiting_dots
if seed_from_tmdb == true
  # Seed movies from TMDB api
  # tmdb has about 704,457 movies
  puts 'Seeding from TMDB'
  waiting_dots
  new_movie_index = 4238
  horror_movies_n = 1
  movie_titles_array = []
  seed_tmdb_movies(new_movie_index, horror_movies_n, movie_titles_array, 61)

  # Writing Movie Seeds to CSV
  csv_file = "seed_list.csv"
  puts "Putting movie seeds into csv file"
  waiting_dots
  CSV.open(csv_file, "wb") do |csv|
    Movie.all.each do |movie_data|
      csv << [movie_data.tmdb_key, movie_data.title, movie_data.poster_url, movie_data.backdrop_image_url, movie_data.overview, movie_data.release_date, movie_data.runtime, movie_data.tagline, movie_data.rating]
    end
  end
else
  # 
  puts 'Seeding from local CSV file'
  waiting_dots
  arr_of_rows = CSV.read("seed_list_curated.csv")

  arr_of_rows.each do |row|
    # url = "https://api.themoviedb.org/3/movie/#{row[0]}?api_key=a7cc25d497366000cfcd64f2c419f406"
    # movie_hash_and_src = [JSON.parse(URI.open(url).read), url]
    # movie_hash = movie_hash_and_src[0]
    # language = movie_hash["original_language"]
    
    movie = Movie.create!(
        poster_url: row[2],
        backdrop_image_url: row[3],
        title: row[1],
        rating: row[8],
        overview: row[4],
        tagline: row[7],
        tmdb_key: row[0],
        runtime: row[6],
        release_date: row[5],
        language: row[9],
    )
    puts "TMDB index: #{movie.tmdb_key}. Title: #{movie.title} #{movie.release_date} Language: #{movie.language}"
  end

  puts 'CSV file movie data seeded'
  waiting_dots
  
end

# Creating 'No Category' Movie list for all movies, then horror sub-genre lists
create_movie_lists

