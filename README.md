# Allgore

A horror movie database, and movie list site. Allgore is a website dedictaed to horror movies with hundreds of movies seeded from TMDB.

<img src="public/Allgore-RespDemoImg.png" width="100%" /> 
<br>


## Built With
- [Rails 6](https://guides.rubyonrails.org/) - Backend / Front-end
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling

## Set Up a Local Development Environment
Download this project code from this Github page. Either do a direct download or use a command line git clone command: 
```
git clone git@github.com:gperilli/allgore.git
```
<br>
<img src="public/github_download_allgore.png" width="25%"/> 

For more information on getting git (version control system) on your local machine, see [this](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

This is a ruby on rails web app, so first set up a rails development environment on your local machine. If you are using Windows, this will probably involve setting up [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), Windows subsystem for Linux, [rbenv](https://github.com/rbenv/rbenv), a ruby environment manager, and Ruby, the language upon which Rails works. Next install [Node.js](https://nodejs.org/en/), [yarn](https://yarnpkg.com/), and [PostgreSQL](https://www.postgresql.org/), then you're good to go.

Install gems
```
bundle install
```
Install JS packages
```
yarn install
```

### DB Setup
Run these commands to set up the database.
```
rails db:create
rails db:migrate
rails db:seed
```

The seed file will import all the movies in the `seed_list_curated.csv` file.

To get more horror movies from the IMDB database, use this command:
```command
rails runner lib/generate_csv_data_from_api_search.rb
```
This will output a csv file with the movie data. Add this manuualy to the `seed_list_curated.csv` file, and then run the Rails seed, `rails db:seed` to get these movies in the database.

Running `rails runner lib/generate_csv_data_from_api_search.rb` can take some time because the code is looking through the IMDB collection and selecting movies within the horror genre.

### Run a server
Run this command to execute the Rails server, then go to `localhost:3000` to see the running app.
```
rails s
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)



