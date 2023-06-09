# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

require_relative 'seed/waiting_dots'
require_relative 'seed/create_movie_lists'
require_relative 'seed/create_movie_list_connectors'


puts 'Emptying database'
waiting_dots
Movielistconnector.destroy_all
List.destroy_all
Movie.destroy_all


puts 'Seeding movies from local CSV file'
waiting_dots
arr_of_rows = CSV.read("db/seed/seed_list_curated.csv")
arr_of_rows.each do |row|
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

puts 'Creating movie lists'
waiting_dots
create_movie_lists

puts 'Connecting movies to lists through CSV data'
waiting_dots
create_movie_list_connectors
