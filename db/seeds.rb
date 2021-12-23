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

def waiting_dots
  3.times do
    print '.'
    sleep(0.2)
  end
  puts ""
end

puts 'cleaning up database'
waiting_dots
Movie.destroy_all
List.destroy_all
Movielistconnector.destroy_all
puts 'databse is clean'
# List.destroy_all

puts 'Creating horror movies'
waiting_dots
# the Le Wagon copy of the API
# url = 'http://tmdb.lewagon.com/movie/top_rated'
# response = JSON.parse(URI.open(url).read)
# https://api.themoviedb.org/3/movie/550?api_key=a7cc25d497366000cfcd64f2c419f406
# response['results'].each do |movie_hash|

# tmdb has about 704,457 movies

new_movie_index = 0
horror_movies_n = 1
movie_titles_array = []


def get_movie_hash(new_movie_index)
  url = "https://api.themoviedb.org/3/movie/#{new_movie_index}?api_key=a7cc25d497366000cfcd64f2c419f406"
  print "#{new_movie_index} #{url}" + "\r"
  $stdout.flush
  movie_hash_and_src = [JSON.parse(URI.open(url).read), url]
end

def get_horror_movie_hash(new_movie_index)
  begin
    # new_movie_index += 1
    movie_hash_and_src = get_movie_hash(new_movie_index)
    movie_hash = movie_hash_and_src[0]
    src = movie_hash_and_src[1]
    if movie_hash["genres"].empty?
      puts "empty genre hash: #{src}"
      new_movie_index += 1
      get_horror_movie_hash(new_movie_index)
    elsif movie_hash["genres"][0]["name"] != "Horror"
      #puts "not horror"
      new_movie_index += 1
      get_horror_movie_hash(new_movie_index)
    #elsif movie_hash["poster_path"].nil?
    #  puts "absent poster image: #{src}"
    #  new_movie_index += 1
    #  get_horror_movie_hash(new_movie_index)
    else
      horror_movie_hash_and_index = [movie_hash, new_movie_index]
    end
  rescue OpenURI::HTTPError => ex
    #puts "Handling missing hash here"
    new_movie_index += 1
    get_horror_movie_hash(new_movie_index)
  end
end

def seed_unique_horror_movies(new_movie_index, movie_titles_array)
  horror_movie_hash_and_index = get_horror_movie_hash(new_movie_index)
  horror_movie_hash = horror_movie_hash_and_index[0]
  new_movie_index = horror_movie_hash_and_index[1]

  if movie_titles_array.include?(horror_movie_hash["original_title"]) == false
     movie_titles_array << horror_movie_hash["original_title"]

    overview = horror_movie_hash["overview"] == "" ? "overview" : horror_movie_hash["overview"]
    backdrop_path = horror_movie_hash["backdrop_path"] == "" ? "backdrop" : horror_movie_hash["backdrop_path"]
    poster_path = horror_movie_hash["poster_path"] == "" ? "poster" : horror_movie_hash["poster_path"]
    backdrop_image_url = "https://image.tmdb.org/t/p/original/#{horror_movie_hash["backdrop_path"]}"
    poster_tmdb_url = "https://image.tmdb.org/t/p/w500/#{horror_movie_hash["poster_path"]}"
    movie = Movie.create!(
      poster_url: poster_tmdb_url,
      backdrop_image_url: backdrop_image_url,
      title: horror_movie_hash["original_title"],
      rating: horror_movie_hash["vote_average"],
      overview: overview,
      tmdb_key: horror_movie_hash["id"],
      runtime: horror_movie_hash["runtime"],
      release_date: horror_movie_hash["release_date"],
    )
    horror_movie_hash_index_and_titlesarray = [horror_movie_hash, new_movie_index, movie_titles_array]
  else
    new_movie_index += 1
    puts "duplicate"
    seed_unique_horror_movies(new_movie_index, movie_titles_array)
  end
end

require 'csv'
csv_file = "seed_list.csv"

while horror_movies_n < 19 do
  horror_movie_hash_tmdbindex_and_titlesarray = seed_unique_horror_movies(new_movie_index, movie_titles_array)
  horror_movie_hash = horror_movie_hash_tmdbindex_and_titlesarray[0]
  new_movie_index = horror_movie_hash_tmdbindex_and_titlesarray[1]
  movie_titles_array = horror_movie_hash_tmdbindex_and_titlesarray[2]

  puts "TMDB index: #{new_movie_index} Horror movie number: #{horror_movies_n}. Title: #{horror_movie_hash["original_title"]}  Instance:"
  new_movie_index += 1
  horror_movies_n += 1
end


# Writing Seeds to CSV
puts "Putting movie seeds into csv file"
waiting_dots
CSV.open(csv_file, "wb") do |csv|
  Movie.all.each do |movie_data|
    csv << [movie_data.tmdb_key, movie_data.title, movie_data.poster_url, movie_data.backdrop_image_url, movie_data.overview]
  end
end

puts "Creating Movie Lists"
waiting_dots

puts "Creating a 'no category' list"
waiting_dots
no_category_list = List.create!(
    name: "No Category",
    overview: "uncategorizable!"
  )
puts ""
puts "Creating a 'scary' list"
waiting_dots
scary_list = List.create!(
    name: "Scary",
    overview: "Frightening!"
  )


puts ""
puts "Creating movielistconnectors to hookup all movies to no category list"
Movie.all.each do |movie|
  movielistconnector = Movielistconnector.create!(
    movie_id: movie.id,
    list_id: no_category_list.id,
  )
  scary_movielistconnector = Movielistconnector.create!(
    movie_id: movie.id,
    list_id: scary_list.id,
  )

  movie.movielistconnectors.all.each do |movielistconnector|
    if List.find(movielistconnector.list_id).name == "Scary"
      movielistconnector.destroy
    end
  end

end

# List.find(Movie.find(1).movielistconnectors.find { |movielistconnector| movielistconnector.movie_id == Movie.find(1).id }.list_id).name



subgenres = [
  ["Vampires", "Whu ha ha ha!", ["Dracula", "Dracula vs. Frankenstein", "From Dusk Till Dawn", "Vampyr - Der Traum des Allan Grey"]],
  ["Zombies", "I'm so hungry", ["Shaun of the Dead", "28 Days Later", "28 Weeks Later", "Resident Evil", "Resident Evil: Apocalypse", "Dawn of the Dead", "Planet Terror", ]],
  ["Aliens", "Take me to your leader!", ["The Thing", "Frankenstein Meets the Space Monster", "Alien"]],
  ["Frankenstein Monsters", "Father, grrrr!", ["Victor Frankenstein", "Frankenstein Meets the Space Monster", "Dracula contra Frankenstein", "Frankenstein Island", "Frankenstein 1970", "La maldición de Frankenstein", "フランケンシュタイン対地底怪獣 バラゴン", "The Horror of Frankenstein", "The Evil of Frankenstein", "La figlia di Frankenstein", "Frankenstein and the Monster from Hell", "Frankenstein Created Woman", "House of Frankenstein", "The Curse of Frankenstein", "Son of Frankenstein", "Frankenstein Meets the Wolf Man", "Frankenstein Must Be Destroyed", "The Ghost of Frankenstein", "Frankenstein Unbound", "Frankenstein Reborn", "恐怖伝説　怪奇！フランケンシュタイン", "The Revenge of Frankenstein", "Flesh for Frankenstein", "Frankenstein"]],
  ["Ghosts", "Boo!", ["リング", "The Blair Witch Project", "The Dark", "The Grudge 2", "The Grudge", "The Others", "The Shining", "Poltergeist"]],
  ["Technology", "Beep beep!", ["Videodrome"]],
  ["Werewolves", "Woof, woof", ["An American Werewolf in London"]],
  ["Evil Men", "Please come in!", ["Saw", "Saw II", "Saw III", "Saw IV", "Psycho"]],
  ["Animals", "Fresh meat", ["Jaws", "Jaws 2", "The Birds"]],
  ["Comedy", "Ha, ha, ha", ["Shaun of the Dead"]]
]


subgenres.each do |subgenre|
  puts "Creating Movie subgenre List: #{subgenre[0]}: #{subgenre[1]} ."
  waiting_dots
  list = List.create!(
    name: subgenre[0],
    overview: subgenre[1]
  )


  subgenre[2].each do |film_name|

    movie_to_add_to_list = Movie.find_by title: film_name

    if movie_to_add_to_list != nil
      movie_to_add_to_list.movielistconnectors.all.each do |movielistconnector|
        if List.find(movielistconnector.list_id).name == "No Category"
          movielistconnector.destroy
        end
      end
      movielistconnector = Movielistconnector.create!(
        movie_id: movie_to_add_to_list.id,
        list_id: list.id,
      )
    end
  end
end

puts ""
puts "Displaying hooked up lists for each movie"
waiting_dots
Movie.all.each do |movie|
  movie_lists_for_this_movie = []
  movie.movielistconnectors.all.each do |movielistconnector|
    movie_lists_for_this_movie << List.find(movielistconnector.list_id).name
  end
  puts "#{movie.title}: #{movie_lists_for_this_movie.join(', ')}"
end
