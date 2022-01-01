


def get_movie_hash(new_movie_index)
  url = "https://api.themoviedb.org/3/movie/#{new_movie_index}?api_key=a7cc25d497366000cfcd64f2c419f406"
  print "#{new_movie_index} #{url}" + "\r"
  $stdout.flush
  movie_hash_and_src = [JSON.parse(URI.open(url).read), url]
end

def horror_movie_query?(genres)
  # Detecting all horror movies among multiple genres
  horror_movie = false
  genres.each do |genre|
    horror_movie = true if genre["name"] == "Horror"
  end
  return horror_movie
end

def get_horror_movie_hash(new_movie_index)
  begin
    movie_hash_and_src = get_movie_hash(new_movie_index)
    movie_hash = movie_hash_and_src[0]
    src = movie_hash_and_src[1]
    horror_movie = horror_movie_query?(movie_hash["genres"])
    if movie_hash["genres"].empty?
      # Handling empty hash
      puts "empty genre hash: #{src}"
      new_movie_index += 1
      get_horror_movie_hash(new_movie_index)
    elsif horror_movie != true 
      # Not a  horror movie
      new_movie_index += 1
      get_horror_movie_hash(new_movie_index)
    else
      horror_movie_hash_and_index = [movie_hash, new_movie_index]
    end
  rescue OpenURI::HTTPError => ex
    # Handling missing hash
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
    tagline = horror_movie_hash["tagline"] == "" ? "tagline" : horror_movie_hash["tagline"]
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
      tagline: tagline,
      tmdb_key: horror_movie_hash["id"],
      runtime: horror_movie_hash["runtime"],
      release_date: horror_movie_hash["release_date"],
      language: horror_movie_hash["original_language"]
    )
    horror_movie_hash_index_and_titlesarray = [horror_movie_hash, new_movie_index, movie_titles_array]
  else
    new_movie_index += 1
    puts "duplicate"
    seed_unique_horror_movies(new_movie_index, movie_titles_array)
  end
end


def seed_tmdb_movies(new_movie_index, horror_movies_n, movie_titles_array, n)
    while horror_movies_n < n do
    horror_movie_hash_tmdbindex_and_titlesarray = seed_unique_horror_movies(new_movie_index, movie_titles_array)
    horror_movie_hash = horror_movie_hash_tmdbindex_and_titlesarray[0]
    new_movie_index = horror_movie_hash_tmdbindex_and_titlesarray[1]
    movie_titles_array = horror_movie_hash_tmdbindex_and_titlesarray[2]
    puts "TMDB index: #{new_movie_index} Horror movie number: #{horror_movies_n}. Title: #{horror_movie_hash["original_title"]}  Instance:"
    new_movie_index += 1
    horror_movies_n += 1
    end
end