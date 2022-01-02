def create_movie_lists
    # Creating 'No Category' Movie list for all movies
    puts "Creating a 'no category' list"
    waiting_dots
    no_category_list = List.create!(
        name: "No Category",
        overview: "uncategorizable!"
    )

    # Creating Horror sub-genre movie lists
    subgenres = [
        ["Vampires", "Wu ha ha ha"], 
        ["Zombies", "I'm hungry."], 
        ["Aliens", "Take me to your leader"], 
        ["Frankenstein Monsters", "Daddy!"], 
        ["Ghosts", "Boo!"], 
        ["Technology", "Beep, beep"], 
        ["Werewolves", "Aoooooooooo"], 
        ["Evil Men", "Please come in"], 
        ["Slasher", "Swish"], 
        ["Animals", "Fresh meat"], 
        ["Comedy", "Ha ha"]
    ]

    subgenres.each do |subgenre|
        puts "Creating movie subgenre List: #{subgenre[0]}"
        waiting_dots
        list = List.create!(
            name: subgenre[0],
            overview: subgenre[1]
        )
    end
end
