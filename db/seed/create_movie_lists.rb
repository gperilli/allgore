require_relative 'waiting_dots'

def create_movie_lists
    # Creating 'No Category' Movie list for all movies
    puts "Creating a no category list"
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
        ["Monsters", "Grrrr!"],
        ["Ghosts", "Boo!"],
        ["Technology", "Beep, beep"],
        ["Werewolves", "Aoooooooooo"],
        ["Serial Killers", "Please come in"],
        ["Slasher", "Swish"],
        ["Animals", "Fresh meat"],
        ["Psychological", "It's all in your head."],
        ["Comedy", "Ha ha"],
        ["Saw Series", "Live or die. Make your choice."],
        ["Alien Series", "In space no one can hear you scream."],
        ["Evil Dead Series", "The Ultimate Experience In Grueling Terror"],
        ["Last Summer Series", "If you're going to bury the truth, make sure it stays buried."]
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
