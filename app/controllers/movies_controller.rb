class MoviesController < ApplicationController

  def index
  @carousel_movie_titles = [] 
  @carousel_movie_titles[0] = "Dracula" 
  @carousel_movie_titles[1] = "Alien" 
  @carousel_movie_titles[2] = "Saw II" 
  @carousel_movie_titles[3] = "A Nightmare on Elm Street" 
  @carousel_movie_titles[4] = "Psycho" 
  @carousel_movie_titles[5] = "The Ring" 

      if params[:query].present?
        sql_query = " \
          movies.title ILIKE :query \
          OR movies.release_date ILIKE :query \
          OR lists.name ILIKE :query \
        "
        @movies = Movie.joins(:lists).where(sql_query, query: "%#{params[:query]}%")
      else
        @movies = Movie.all #Movie.page params[:page]
      end
    
    # @lists = List.all
  end

  def show
  @movie = Movie.find(params[:id])
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :rating, :poster_url, :release_date, :runtime, :id)
  end

end
