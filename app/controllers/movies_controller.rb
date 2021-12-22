class MoviesController < ApplicationController

  def index
    @movies = Movie.all #Movie.page params[:page]
    @lists = List.all
  end

  def show
  @movie = Movie.find(params[:id])
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :rating, :poster_url, :release_date, :runtime, :id)
  end

end
