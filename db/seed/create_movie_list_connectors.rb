require_relative 'waiting_dots'

def create_movie_list_connectors
    puts "Creating movielistconnectors to hookup all movies to no category list"
    waiting_dots
    no_category_list = List.find_by name: "No Category"
    Movie.all.each do |movie|
        movielistconnector = Movielistconnector.create!(
            movie_id: movie.id,
            list_id: no_category_list.id,
        )
    end
    puts "Looking through csv file for movie subgenres to hookup"
    waiting_dots
    arr_of_rows = CSV.read("db/seed/seed_list_curated.csv")
    arr_of_rows.each do |row|
        [10, 11, 12].each do |row_column|
            if row[row_column] != nil
                movie_to_add_to_list = Movie.find_by title: row[1]
                list_to_add_to_movie = List.find_by name: row[row_column]
                # Destroying the no category list connector
                movie_to_add_to_list.movielistconnectors.all.each do |movielistconnector|
                    if List.find(movielistconnector.list_id).name == "No Category"
                    movielistconnector.destroy
                    end
                end
                # Adding movie-list connector
                movielistconnector = Movielistconnector.create!(
                    movie_id: movie_to_add_to_list.id,
                    list_id: list_to_add_to_movie.id,
                )
                puts "#{movie_to_add_to_list.title}: #{list_to_add_to_movie.name}"
            end
        end
    end
end
