# frozen_string_literal: true

class ListsController < ApplicationController
  def index
    @list_card_covers = {}
    @list_card_covers[:zombies] = 'Dawn of the Dead'
    @list_card_covers[:animals] = 'Jaws'
    @list_card_covers[:aliens] = 'AVP: Alien vs. Predator'

    # Putting No category list at end
    @lists = List.all[1..List.count] << List.first
  end

  def show
    @list = List.find(params[:id])
    @list_movies = @list.movies
    @movies_in_list = @list_movies.page params[:page]
  end

  private

  def list_params
    params.require(:list).permit(:name, :overview)
  end
end
