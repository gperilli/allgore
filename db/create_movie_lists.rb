def create_movie_lists
    # Creating Movie Lists
    puts "Creating Movie Lists"
    waiting_dots

    # Creating 'No Category' Movie list for all movies
    puts "Creating a 'no category' list"
    waiting_dots
    no_category_list = List.create!(
        name: "No Category",
        overview: "uncategorizable!"
    )

    puts ""
    puts "Creating movielistconnectors to hookup all movies to no category list"
    Movie.all.each do |movie|
    movielistconnector = Movielistconnector.create!(
        movie_id: movie.id,
        list_id: no_category_list.id,
    )
    end


    # Creating Horror sub-genre movie lists
    subgenres = [
    ["Vampires", "Whu ha ha ha", ["Dracula", "Dracula vs. Frankenstein", "From Dusk Till Dawn", "Vampyr - Der Traum des Allan Grey"]],
    ["Zombies", "I'm so hungry", ["Shaun of the Dead", "28 Days Later", "28 Weeks Later", "Resident Evil", "Resident Evil: Apocalypse", "Dawn of the Dead", "Planet Terror", ]],
    ["Aliens", "Take me to your leader", ["The Thing", "Frankenstein Meets the Space Monster", "Alien"]],
    ["Frankenstein Monsters", "Father, grrrr!", ["Victor Frankenstein", "Frankenstein Meets the Space Monster", "Dracula contra Frankenstein", "Frankenstein Island", "Frankenstein 1970", "La maldición de Frankenstein", "フランケンシュタイン対地底怪獣 バラゴン", "The Horror of Frankenstein", "The Evil of Frankenstein", "La figlia di Frankenstein", "Frankenstein and the Monster from Hell", "Frankenstein Created Woman", "House of Frankenstein", "The Curse of Frankenstein", "Son of Frankenstein", "Frankenstein Meets the Wolf Man", "Frankenstein Must Be Destroyed", "The Ghost of Frankenstein", "Frankenstein Unbound", "Frankenstein Reborn", "恐怖伝説　怪奇！フランケンシュタイン", "The Revenge of Frankenstein", "Flesh for Frankenstein", "Frankenstein"]],
    ["Ghosts", "Boo!", ["リング", "The Blair Witch Project", "The Dark", "The Grudge 2", "The Grudge", "The Others", "The Shining", "Poltergeist"]],
    ["Technology", "Beep beep", ["Videodrome"]],
    ["Werewolves", "Woof, woof", ["An American Werewolf in London"]],
    ["Evil Men", "Please come in", ["Saw", "Saw II", "Saw III", "Saw IV", "Psycho"]],
    ["Slasher", "Swish", ["A Nightmare on Elm Street", "Psycho"]],
    ["Animals", "Fresh meat", ["Jaws", "Jaws 2", "The Birds"]],
    ["Comedy", "Ha, ha, ha", ["Shaun of the Dead"]]
    ]

    # Creating Horror sub-genre movie lists, then hooking up movies to lists with Movielistconnectors
    subgenres.each do |subgenre|
        puts "Creating Movie subgenre List: #{subgenre[0]}: #{subgenre[1]}! #{subgenre[2].count} movies in list."
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
end
# \list all movies with associated lists
# puts ""
# puts "Displaying hooked up lists for each movie"
# waiting_dots
# Movie.all.each do |movie|
#   movie_lists_for_this_movie = []
#   movie.movielistconnectors.all.each do |movielistconnector|
#     movie_lists_for_this_movie << List.find(movielistconnector.list_id).name
#   end
#   puts "#{movie.title}: #{movie_lists_for_this_movie.join(', ')}"
# end
