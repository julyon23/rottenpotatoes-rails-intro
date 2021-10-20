class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect_to movies_path if params[:home] == "1"
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings].present? ? params[:ratings].keys : Movie.all_ratings
    #if not params[:ratings].present?
     # @movies = Movie.with_ratings(@ratings_to_show)
    if params[:header_clicked] == 'movie_title'
      @title_hilite = 'hilite bg-warning'
      @movies = Movie.with_ratings(@ratings_to_show).sort_by(&:title)
    elsif params[:header_clicked] == 'release_date'
      @release_date_hilite = 'hilite bg-warning'
      @movies = Movie.with_ratings(@ratings_to_show).sort_by(&:release_date)
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    session[:ratings] = params[:ratings]
    session[:header_clicked] = params[:header_clicked]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
