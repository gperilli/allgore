# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @carousel_movie_titles = []
    @carousel_movie_titles[0] = 'The Shining'
    @carousel_movie_titles[1] = 'Alien'
    @carousel_movie_titles[2] = 'Saw II'
    @carousel_movie_titles[3] = 'A Nightmare on Elm Street'
    @carousel_movie_titles[4] = 'American Psycho'
    @carousel_movie_titles[5] = 'The Ring'

    @last_page = (Movie.all.length.to_f / 60).ceil

    if params[:query].present?
      sql_query = " \
        movies.title ILIKE :query \
        OR movies.release_date ILIKE :query \
        OR lists.name ILIKE :query \
      "
      @movies_total = Movie.joins(:lists).where(sql_query, query: "%#{params[:query]}%").count
      @movies = Movie.joins(:lists).where(sql_query, query: "%#{params[:query]}%").page params[:page]

    else
      @movies_total = Movie.all.count
      @movies = Movie.page params[:page]
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :rating, :poster_url, :release_date, :runtime, :id)
  end
end
